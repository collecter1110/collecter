import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:collecter/data/services/image_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../../components/pop_up/toast.dart';
import '../../main.dart';
import '../model/category_model.dart';
import '../model/collection_model.dart';
import '../model/selecting_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../provider/collection_provider.dart';
import 'data_service.dart';
import 'locator.dart';
import 'storage_service.dart';

class ApiService {
  static final storage = FlutterSecureStorage();
  static final SupabaseClient _supabase = Supabase.instance.client;
  static Session? currentSession = _supabase.auth.currentSession;
  static User? authUser = _supabase.auth.currentUser;
  static RealtimeChannel? _myCollectionsChannel;
  static List<int> _blockedUserIds = [];

  static Future<void> trackError(
      dynamic exception, StackTrace stackTrace, String description) async {
    String? userId = await storage.read(key: 'USER_ID');

    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setContexts('USER_INFO', {'userId': userId});
        scope.setContexts('API Request', {
          'description': description,
        });
      },
    );
    if (exception is PlatformException) {
      if (exception.message == 'The user did not allow photo access.') {
        await ImageService.getPermission();
      } else {
        Toast.notify('데이터를 불러올 수 없습니다.\n잠시후에 다시 시도해주세요.');
      }
    } else if (exception is SocketException) {
      Toast.notify('네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.');
    } else if (exception is RealtimeSubscribeException) {
      // Toast.notify('구독을 초기화 하고 있습니다. 잠시만 기다려 주세요');
    } else if (exception is TimeoutException) {
      Toast.notify('요청 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.');
    } else if (exception is FormatException) {
      Toast.notify('데이터 형식 오류가 발생했습니다. 다시 시도해 주세요.');
    } else if (exception is PlatformException) {
      Toast.notify('플랫폼 오류가 발생했습니다. 설정을 확인해 주세요.');
    } else if (exception is HttpException) {
      Toast.notify('서버 요청 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    } else if (exception is AuthException) {
      if (exception.code == 'session_expired') {
        Toast.notify('세션이 만료되었습니다.\n다시 로그인 해주세요.');
        MyApp.restartApp();
      } else if (exception.code == 'user_banned') {
        Toast.notify(
            '3회 이상 신고로 계정이\n1주일간 정지되었습니다.\n문의 : contact.collect@gmail.com');
      } else if (exception.code == 'otp_expired') {
      } else if (exception.code == 'validation_failed') {
      } else {
        Toast.notify('인증 오류가 발생했습니다. 다시 로그인해 주세요.');
      }
    } else if (exception is PostgrestException) {
      if (exception.code == 'PGRST116') {
        Toast.notify('삭제된 게시물 입니다.');
      }
    } else {
      Toast.notify('죄송합니다.\n현재 일시적인 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.');
    }
  }

  static Future<void> authListener() async {
    final authSubscription =
        _supabase.auth.onAuthStateChange.listen((data) async {
      try {
        final AuthChangeEvent event = data.event;
        currentSession = data.session;
        authUser = _supabase.auth.currentUser;

        print('Auth event: $event');

        switch (event) {
          case AuthChangeEvent.initialSession:
            await handleSaveAccessTokens();
            break;
          case AuthChangeEvent.signedIn:
            await handleSaveAccessTokens();
            break;
          case AuthChangeEvent.tokenRefreshed:
            await handleSaveAccessTokens();
            break;
          case AuthChangeEvent.signedOut:
            await StorageService.deleteStorageData();
            break;
          default:
            break;
        }
      } catch (e, stackTrace) {
        trackError(e, stackTrace, 'Exception in authListener');
        debugErrorMessage('authListener exception: ${e}');
        throw Exception('authListener exception: ${e}');
      }
    });
  }

  static Future<void> handleSaveAccessTokens() async {
    try {
      if (currentSession != null && currentSession!.accessToken.isNotEmpty) {
        print('유효한 세션 - 토큰을 저장합니다.');
        await StorageService.saveTokens(
          currentSession!.accessToken,
          currentSession!.refreshToken ?? '',
        );
      } else {
        print('세션이 만료되었거나 없습니다.');
        await StorageService.deleteStorageData();
        await _supabase.auth.signOut();
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in handleSaveAccessTokens');
      debugErrorMessage('handleSaveAccessTokens exception: ${e}');
    }
  }

  static Future<bool> checkEmailDuplicate(String email) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      return response == null;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in checkEmailDuplicate');
      debugErrorMessage('checkEmailDuplicate exception: ${e}');
      return false;
    }
  }

  static Future<bool> sendOtp(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );

      print('OTP sent to $email');
      return true;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in sendOtp');
      debugErrorMessage('sendOtp exception: ${e}');
      return false;
    }
  }

  static Future<bool> checkOtp(String otp, String email) async {
    try {
      final AuthResponse response = await _supabase.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: otp,
      );

      if (response.user != null) {
        final response = await _supabase
            .from('userinfo')
            .select('user_id')
            .eq('email', email)
            .single();
        int userId = response['user_id'];
        await storage.write(key: 'USER_ID', value: userId.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in checkOtp');
      debugErrorMessage('checkOtp exception: ${e}');
      return false;
    }
  }

  static Future<bool> checkUserNameDuplicate(String userName) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select('name')
          .eq('name', userName)
          .maybeSingle();

      return response == null;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in checkUserNameDuplicate');
      debugErrorMessage('checkUserNameDuplicate exception: ${e}');
      return false;
    }
  }

  static Future<void> setUserInfo(
      String userName, String? userDescription) async {
    try {
      String? _email = authUser!.email;
      if (_email != null) {
        await _supabase.from('userinfo').update({
          'name': userName,
          'description': userDescription,
        }).eq('email', _email);
      } else {
        print('authUser email is null');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in setUserInfo');
      debugErrorMessage('setUserInfo exception: ${e}');
      throw Exception('setUserInfo exception: ${e}');
    }
  }

  static Future<void> emailLogin(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );

      print('OTP sent to $email');
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in emailLogin');
      debugErrorMessage('emailLogin exception: ${e}');
      throw Exception('emailLogin exception: ${e}');
    }
  }

  static Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in logout');
      debugErrorMessage('logout exception: ${e}');
      throw Exception('logout exception: ${e}');
    }
  }

  static Future<void> deleteAuthUser() async {
    final userUuid = authUser?.id;

    if (userUuid == null) {
      print('사용자가 로그인되어 있지 않습니다.');
      return;
    }

    try {
      await _supabase
          .rpc('delete_user_by_owner', params: {'user_uuid': userUuid});
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteAuthUser');
      debugErrorMessage('deleteAuthUser exception: $e');
      throw Exception('deleteAuthUser exception: ${e}');
    }
  }

  static Future<void> cancelMembership() async {
    final supabaseUrl = await storage.read(key: 'SUPABASE_URL');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    final url = Uri.parse('$supabaseUrl/functions/v1/delete-user');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        print('User deleted successfully.');
      } else {
        print('Failed to delete user: ${response.body}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in cancelMembership');
      debugErrorMessage('cancelMembership exception: ${e}');
      throw Exception('cancelMembership exception: ${e}');
    }
  }

  static Future<void> deleteStorageFolder() async {
    final supabaseUrl = await storage.read(key: 'SUPABASE_URL');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    final userIdString = await storage.read(key: 'USER_ID');
    try {
      final edgeFunctionUrl =
          Uri.parse('$supabaseUrl/functions/v1/delete-folder');

      final response = await http.post(
        edgeFunctionUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken}',
        },
        body: jsonEncode({'folderPath': userIdString}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Deleted files: ${responseBody['deletedFilePaths']}');
      } else {
        print('Error: ${response.body}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteStorageFolder');
      debugErrorMessage('deleteStorageFolder exception: ${e}');
      throw Exception('deleteStorageFolder exception: ${e}');
    }
  }

  static Future<UserInfoModel> getUserInfo() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      final response = await _supabase
          .from('userinfo')
          .select('name, email, description, image_file_path, user_id')
          .eq('user_id', userId)
          .single();

      if (response.isNotEmpty) {
        final responseData = response;
        UserInfoModel userInfoData = UserInfoModel.fromJson(responseData);
        return Future.value(userInfoData);
      } else {
        throw Exception('Response code error <getUserInfo>');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getUserInfo');
      debugErrorMessage('getUserInfo exception: ${e}');
      throw Exception('getUserInfo exception: ${e}');
    }
  }

  static Future<List<SelectingModel>> getSelectings(String properties) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final responseData = await _supabase
          .from('selectingview')
          .select(properties)
          .eq('user_id', userId)
          .single();

      List<dynamic> jsonDataList = responseData[properties];

      List<SelectingModel> selectingModelList =
          jsonDataList.map((item) => SelectingModel.fromJson(item)).toList();

      return Future.value(selectingModelList);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getSelectings');
      debugErrorMessage('getSelectings exception: ${e}');
      throw Exception('getSelectings exception: ${e}');
    }
  }

  static Future<List<SelectionModel>> getSelections(
    int collectionId,
  ) async {
    try {
      final responseData = await _supabase
          .from('selections')
          .select(
              'category_id, collection_id, selection_id, title, image_file_paths, keywords, owner_name, owner_id, is_selecting')
          .eq('collection_id', collectionId);

      List<SelectionModel> selections = responseData.map((item) {
        List? imageFilePaths = item['image_file_paths'] as List<dynamic>?;
        String? firstImagePath =
            imageFilePaths != null && imageFilePaths.isNotEmpty
                ? imageFilePaths.first as String
                : null;

        return SelectionModel.fromJson({
          ...item,
        }, thumbFilePath: firstImagePath);
      }).toList();

      return Future.value(selections);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getSelections');
      debugErrorMessage('getSelections exception: ${e}');
      throw Exception('getSelections exception: ${e}');
    }
  }

  static Future<SelectionModel> getSelectionDetail(
    int collectionId,
    int selectionId,
  ) async {
    try {
      final responseData = await _supabase
          .from('selections')
          .select(
              'category_id,collection_id, selection_id, user_id, owner_id, title, description, image_file_paths, is_ordered, link, items, keywords, created_at, owner_name, is_selectable, is_selecting')
          .eq('collection_id', collectionId)
          .eq('selection_id', selectionId)
          .single();

      SelectionModel selectionDetailModel =
          SelectionModel.fromJson(responseData);

      return Future.value(selectionDetailModel);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getSelectionDetail');
      debugErrorMessage('getSelectionDetail exception: ${e}');
      throw Exception('getSelectionDetail exception: ${e}');
    }
  }

  static Future<List<CategoryModel>> getCategoryInfo() async {
    try {
      final responseData = await _supabase.from('categoryinfo').select('*');
      final List<CategoryModel> categoryInfo =
          responseData.map((item) => CategoryModel.fromJson(item)).toList();
      return categoryInfo;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getCategoryInfo');
      debugErrorMessage('getCategoryInfo exception: ${e}');
      throw Exception('getCategoryInfo exception: ${e}');
    }
  }

  static Future<String> getCollectionTitle(int collectionId) async {
    try {
      final responseData = await _supabase
          .from('collections')
          .select('title')
          .eq('id', collectionId)
          .single();

      String title = responseData['title'];

      return title;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getCollectionTitle');
      debugErrorMessage('getCollectionTitle exception: ${e}');
      throw Exception('getCollectionTitle exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> getRankingCollections() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      final response = await _supabase
          .rpc('get_ranking_collections', params: {'input_user_id': userId});

      if (response is List<dynamic>) {
        List<CollectionModel> rankingCollections = response
            .map((item) =>
                CollectionModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return rankingCollections;
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingCollections');
      debugErrorMessage('getRankingCollections exception: $e');
      throw Exception('getRankingCollections exception: $e');
    }
  }

  static Future<List<SelectionModel>> getRankingSelections() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final response = await _supabase
          .rpc('get_ranking_selections', params: {'input_user_id': userId});

      if (response is List<dynamic>) {
        List<SelectionModel> rankingSelections = response.map((item) {
          List? imageFilePaths = item['image_file_paths'] as List<dynamic>?;
          String? firstImagePath =
              imageFilePaths != null && imageFilePaths.isNotEmpty
                  ? imageFilePaths.first as String
                  : null;

          return SelectionModel.fromJson({
            ...item,
          }, thumbFilePath: firstImagePath);
        }).toList();

        return rankingSelections;
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingSelections');
      debugErrorMessage('getRankingSelections exception: $e');
      throw Exception('getRankingSelections exception: $e');
    }
  }

  static Future<List<UserInfoModel>> getRankingUsers() async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select()
          .not('user_id', 'in', _blockedUserIds)
          .order('created_at', ascending: false)
          .limit(10);

      List<UserInfoModel> rankingUsers = (response as List<dynamic>)
          .map((item) => UserInfoModel.fromJson(item))
          .toList();

      return rankingUsers;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingUsers');
      debugErrorMessage('getRankingUsers exception: $e');
      throw Exception('getRankingUsers exception: $e');
    }
  }

  static Future<void> initializeMyCollections() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final responseData =
          await _supabase.from('collections').select('').eq('user_id', userId);

      List<CollectionModel> collections = responseData.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();
      locator<CollectionProvider>().initializeMyCollections = collections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in initializeMyCollections');
      debugErrorMessage('initializeMyCollections exception: ${e}');
      throw Exception('initializeMyCollections exception: ${e}');
    }
  }

  static Future<void> myCollectionsSubscription() async {
    try {
      print('myCollectionsSubscription');
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      Timer? _debounceTimer;
      _myCollectionsChannel = _supabase
          .channel('public:collections')
          .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: userId,
              ),
              table: 'collections',
              callback: (payload) async {
                print('내 콜랙션 callback');
                Map<String, dynamic> newRecord = payload.newRecord;
                Map<String, dynamic> oldRecord = payload.oldRecord;
                if (_debounceTimer?.isActive ?? false) {
                  _debounceTimer?.cancel();
                }
                _debounceTimer =
                    Timer(const Duration(milliseconds: 300), () async {
                  if (payload.eventType == PostgresChangeEvent.insert) {
                    CollectionModel newCollectionData =
                        CollectionModel.fromJson(newRecord);
                    locator<CollectionProvider>().upsertMyCollections =
                        newCollectionData;
                    await DataService.reloadLocalCollectionData(
                        newRecord['id']);
                  } else if (payload.eventType == PostgresChangeEvent.update) {
                    CollectionModel newCollectionData =
                        CollectionModel.fromJson(newRecord);
                    locator<CollectionProvider>().upsertMyCollections =
                        newCollectionData;
                    await DataService.reloadLocalCollectionData(
                        newRecord['id']);
                  } else if (payload.eventType == PostgresChangeEvent.delete) {
                    locator<CollectionProvider>().deleteMyCollections =
                        oldRecord['id'];
                    await DataService.reloadLocalCollectionData(
                        oldRecord['id']);
                  }
                });
              })
          .subscribe();
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getCollections');
      debugErrorMessage('getCollections exception: ${e}');
      throw Exception('getCollections exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> getLikeCollections() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final response = await _supabase
          .from('likes')
          .select('collections(*)')
          .eq('user_id', userId);

      final List<CollectionModel> likeCollections = response
          .where((item) =>
              item['collections'] != null &&
              !_blockedUserIds.contains(item['collections']['user_id'] as int))
          .map((item) => CollectionModel.fromJson(item['collections']))
          .toList();

      return likeCollections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getLikeCollections');
      debugErrorMessage('getLikeCollections exception: ${e}');
      throw Exception('getLikeCollections exception: ${e}');
    }
  }

  static Future<CollectionModel> getCollectionDetail(int collectionId) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      final responseData = await _supabase.from('collections').select('''
        category_id,
        id, 
        title, 
        description, 
        created_at, 
        image_file_path, 
        tags, 
        user_id,
        user_name, 
        primary_keywords, 
        selection_num, 
        like_num, 
        likes(user_id),
        is_public
        ''').eq('id', collectionId).single();

      bool hasLiked = (responseData['likes'] as List<dynamic>)
          .any((like) => like['user_id'] == userId);

      CollectionModel collection =
          CollectionModel.fromJson(responseData, hasLiked: hasLiked);

      return collection;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getCollectionDetail');
      debugErrorMessage('getCollectionDetail exception: ${e}');
      throw Exception('getCollectionDetail exception: ${e}');
    }
  }

  static Future<void> copyImage(
    String sourceFolderPath,
    String destinationFolderPath,
    String fileName,
    int collectionId,
  ) async {
    try {
      final supabaseUrl = await storage.read(key: 'SUPABASE_URL');
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final edgeFunctionUrl = Uri.parse('$supabaseUrl/functions/v1/copy-image');

      final response = await http.post(
        edgeFunctionUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken}',
        },
        body: jsonEncode({
          'sourceFolderPath': sourceFolderPath,
          'destinationFolderPath': destinationFolderPath,
          'fileName': fileName,
          'userId': userId,
          'collectionId': collectionId
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('File copied successfully: ${responseBody['message']}');
      } else {
        print('Error: ${response.body}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in copyImage');
      debugErrorMessage('copyImage exception: ${e}');
      throw Exception('copyImage exception: ${e}');
    }
  }

  static Future<List<String>> uploadAndGetImageFileNames(
      List<XFile> xfiles, String folderPath) async {
    final supabaseUrl = await storage.read(key: 'SUPABASE_URL');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      final edgeFunctionUrl =
          Uri.parse('$supabaseUrl/functions/v1/upload-images');
      List<String> fileNames = [];
      List<String> filePaths = [];
      List<Map<String, dynamic>> fileMetadata = [];
      List<int> combinedFileBytes = [];

      for (XFile xfile in xfiles) {
        final fileBytes = await xfile.readAsBytes();
        String fileName = path.basename(xfile.path);
        final filePath = '$userId/$folderPath/$fileName';

        filePaths.add(filePath);
        fileNames.add(fileName);

        fileMetadata.add({
          "fileName": fileName,
          "filePath": filePath,
          "start": combinedFileBytes.length,
          "length": fileBytes.length,
        });

        combinedFileBytes.addAll(fileBytes);
      }

      final payload = jsonEncode({"filePaths": filePaths});
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      try {
        final response = await http.post(
          edgeFunctionUrl,
          headers: headers,
          body: payload,
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);

          final presignedUrls = responseBody['presignedUrls'] as List;
          if (presignedUrls.isEmpty) {
            throw Exception('No presigned URLs returned');
          }

          for (int i = 0; i < presignedUrls.length; i++) {
            final urlInfo = presignedUrls[i];
            final filePath = urlInfo['filePath'];
            final presignedUrl = urlInfo['url'];

            final start = fileMetadata[i]["start"] as int;
            final length = fileMetadata[i]["length"] as int;
            final fileBytes = combinedFileBytes.sublist(start, start + length);

            try {
              final uploadResponse = await http.put(
                Uri.parse(presignedUrl),
                headers: {
                  'Content-Type': 'application/octet-stream',
                  'X-File-Metadata': jsonEncode(fileMetadata[i]),
                },
                body: fileBytes,
              );

              if (uploadResponse.statusCode != 200) {
                throw Exception(
                    'Failed to upload file $filePath (status: ${uploadResponse.statusCode}): ${uploadResponse.body}');
              }
            } catch (e, stackTrace) {
              trackError(e, stackTrace, 'Exception in upload to aws s3');
              debugErrorMessage(
                  'Exception in upload to aws s3: ${e.toString()}');
              throw Exception('Exception in upload to aws s3: ${e.toString()}');
            }
          }
          return fileNames;
        } else {
          throw Exception(
              'Failed to get presigned URLs (status: ${response.statusCode}): ${response.body}');
        }
      } catch (e, stackTrace) {
        trackError(e, stackTrace, 'Exception in edgeFunction upload-images');
        debugErrorMessage(
            'edgeFunction upload-images exception: ${e.toString()}');
        throw Exception(
            'edgeFunction upload-images exception: ${e.toString()}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in uploadAndGetImageFileNames');
      debugErrorMessage(
          'uploadAndGetImageFileNames exception: ${e.toString()}');
      throw Exception('uploadAndGetImageFileNames exception: ${e.toString()}');
    }
  }

  static Future<void> addCollection(int categoryId, String title,
      String? description, List<String>? tags, bool isPublic) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      await _supabase.from('collections').insert({
        'category_id': categoryId,
        'user_id': userId,
        'title': title,
        'description': description,
        'tags': tags,
        'is_public': isPublic,
      });
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in addCollection');
      debugErrorMessage('addCollection exception: ${e}');
      throw Exception('addCollection exception: ${e}');
    }
  }

  static Future<void> addSelections(
      int categoryId,
      int collectionId,
      String title,
      String? description,
      List<String>? imageFilePaths,
      List<Map<String, dynamic>> keywords,
      String? link,
      List<Map<String, dynamic>>? items,
      bool isOrder,
      bool isSelectable) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      await _supabase.from('selections').insert({
        'category_id': categoryId,
        'owner_id': userId,
        'user_id': userId,
        'collection_id': collectionId,
        'selection_id': null,
        'title': title,
        'description': description,
        'image_file_paths': imageFilePaths,
        'keywords': keywords,
        'link': link,
        'items': items,
        'is_ordered': isOrder,
        'is_selectable': isSelectable,
      });
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in addSelections');
      debugErrorMessage('addSelections exception: ${e}');
      throw Exception('addSelections exception: ${e}');
    }
  }

  static Future<List<Map<String, dynamic>>> addKeywords(
    List<String> keywords,
    int categoryId,
  ) async {
    try {
      List<Map<String, dynamic>> newKeywordEntries = keywords
          .map(
              (keyword) => {'keyword_name': keyword, 'category_id': categoryId})
          .toList();

      await _supabase.from('keywordinfo').insert(newKeywordEntries);

      final response = await _supabase
          .from('keywordinfo')
          .select('keyword_name, keyword_id')
          .eq('category_id', categoryId)
          .filter('keyword_name', 'in', keywords);

      return response;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in addKeywords');
      debugErrorMessage('addKeywords exception: ${e}');
      throw Exception('addKeywords exception: ${e}');
    }
  }

  Future<void> actionLike(int collectionId) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      await _supabase.from('likes').insert({
        'user_id': userId,
        'collection_id': collectionId,
      });
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in actionLike');
      debugErrorMessage('actionLike exception: ${e}');
      throw Exception('actionLike exception: ${e}');
    }
  }

  Future<void> actionUnlike(int collectionId) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    try {
      await _supabase
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('collection_id', collectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in actionUnlike');
      debugErrorMessage('actionUnlike exception: ${e}');
      throw Exception('actionUnlike exception: ${e}');
    }
  }

  static Future<void> editCollection(
      int categoryId,
      int collectionId,
      String title,
      String? description,
      String? imageFilePath,
      List<String>? tags,
      bool isPublic) async {
    try {
      await _supabase.from('collections').update({
        'category_id': categoryId,
        'title': title,
        'description': description,
        'image_file_path': imageFilePath,
        'tags': tags,
        'is_public': isPublic,
      }).eq('id', collectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in editCollection');
      debugErrorMessage('editCollection exception: ${e}');
      throw Exception('editCollection exception: ${e}');
    }
  }

  static Future<void> editSelection(
    int categoryId,
    int collectionId,
    int selectionId,
    String title,
    String? description,
    List<String>? imageFilePaths,
    List<Map<String, dynamic>> keywords,
    String? link,
    List<Map<String, dynamic>>? items,
    bool isOrder,
    bool isSelectable,
  ) async {
    try {
      await _supabase
          .from('selections')
          .update({
            'category_id': categoryId,
            'title': title,
            'description': description,
            'image_file_paths': imageFilePaths,
            'keywords': keywords,
            'link': link,
            'items': items,
            'is_ordered': isOrder,
            'is_selectable': isSelectable,
          })
          .eq('collection_id', collectionId)
          .eq('selection_id', selectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in editSelection');
      debugErrorMessage('editSelection exception: ${e}');
      throw Exception('editSelection exception: ${e}');
    }
  }

  static Future<void> editUserInfo(
    String name,
    String? description,
    String? imageFilePath,
  ) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    try {
      await _supabase.from('userinfo').update({
        'name': name,
        'description': description,
        'image_file_path': imageFilePath,
      }).eq('user_id', userId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in editUserInfo');
      debugErrorMessage('editUserInfo exception: ${e}');
      throw Exception('editUserInfo exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> searchCollectionsByKeyword(
      String searchText) async {
    try {
      final response = await _supabase
          .rpc('search_collections_by_keyword', params: {'query': searchText});

      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response);

      List<CollectionModel> collections = responseData.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();

      return collections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in searchCollectionsByKeyword');
      debugErrorMessage('searchCollectionsByKeyword exception: ${e}');
      throw Exception('searchCollectionsByKeyword exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> searchCollectionsByTag(
      String searchText) async {
    try {
      final response = await _supabase
          .rpc('search_collections_by_tag', params: {'query': searchText});

      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response);

      List<CollectionModel> collections = responseData.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();

      return collections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in searchCollectionsByTag');
      debugErrorMessage('searchCollectionsByTag exception: ${e}');
      throw Exception('searchCollectionsByTag exception: ${e}');
    }
  }

  static Future<List<SelectionModel>> searchSelections(
      String searchText) async {
    try {
      final response = await _supabase
          .rpc('search_selections_by_keyword', params: {'query': searchText});

      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response);

      List<SelectionModel> selections = responseData.map((item) {
        List? imageFilePaths = item['image_file_paths'] as List<dynamic>?;
        String? firstImagePath =
            imageFilePaths != null && imageFilePaths.isNotEmpty
                ? imageFilePaths.first as String
                : null;

        return SelectionModel.fromJson({
          ...item,
        }, thumbFilePath: firstImagePath);
      }).toList();

      return selections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in searchSelections');
      debugErrorMessage('searchSelections exception: ${e}');
      throw Exception('searchSelections exception: ${e}');
    }
  }

  static Future<List<UserInfoModel>> searchUsers(String searchText) async {
    try {
      final response =
          await _supabase.rpc('search_users', params: {'query': searchText});

      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response);

      List<UserInfoModel> users = responseData.map((item) {
        return UserInfoModel.fromJson(item);
      }).toList();
      return users;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in searchUsers');
      debugErrorMessage('searchUsers exception: ${e}');
      throw Exception('searchUsers exception: ${e}');
    }
  }

  static Future<UserInfoModel?> getOtherUserInfo(int userId) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select('name, description, image_file_path, user_id')
          .eq('user_id', userId)
          .single();

      if (response.isNotEmpty) {
        final responseData = response;
        UserInfoModel userInfoData = UserInfoModel.fromJson(responseData);
        return Future.value(userInfoData);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getOtherUserInfo');
      debugErrorMessage('getOtherUserInfo exception: ${e}');
      throw Exception('getOtherUserInfo exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> getUsersCollections(int userId) async {
    try {
      final responseData = await _supabase.from('collections').select('''
        category_id,
        id, 
        title, 
        image_file_path, 
        user_id,
        user_name, 
        primary_keywords, 
        selection_num, 
        is_public
        ''').eq('user_id', userId);

      List<CollectionModel> collections = responseData.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();

      return collections;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getUsersCollections');
      debugErrorMessage('getUsersCollections exception: ${e}');
      throw Exception('getUsersCollections exception: ${e}');
    }
  }

  static Future<void> deleteCollection(CollectionModel collection) async {
    try {
      int selectionNum = collection.selectionNum!;
      if (collection.imageFilePath != null) {
        List<String> imageFilePaths = [collection.imageFilePath!];
        await deleteStorageImages('collections', imageFilePaths);
      }
      if (selectionNum != 0) {
        final selectionImageFilePaths = await _supabase
            .from('selections')
            .select('image_file_paths')
            .eq('collection_id', collection.id)
            .eq('owner_id', collection.userId);

        List<String> imageFilePaths = [];

        for (var item in selectionImageFilePaths) {
          if (item['image_file_paths'] != null) {
            imageFilePaths.addAll(List<String>.from(item['image_file_paths']));
          }
        }
        if (imageFilePaths.isNotEmpty) {
          await deleteStorageImages('selections', imageFilePaths);
        }
      }
      await _supabase.from('collections').delete().eq('id', collection.id);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteCollection');
      debugErrorMessage('deleteCollection exception: ${e}');
      throw Exception('deleteCollection exception: ${e}');
    }
  }

  static Future<void> deleteSelection(SelectionModel selection) async {
    try {
      if (selection.isSelecting != true && selection.imageFilePaths != null) {
        List<String> imageFilePaths = [];
        imageFilePaths = List<String>.from(selection.imageFilePaths!);
        await deleteStorageImages('selections', imageFilePaths);
      }

      await _supabase
          .from('selections')
          .delete()
          .eq('collection_id', selection.collectionId)
          .eq('selection_id', selection.selectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteSelection');
      debugErrorMessage('deleteSelection exception: ${e}');
      throw Exception('deleteSelection exception: ${e}');
    }
  }

  static Future<void> deleteStorageImages(
    String folderPath,
    List<String> imageFilePaths,
  ) async {
    final supabaseUrl = await storage.read(key: 'SUPABASE_URL');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      final edgeFunctionUrl =
          Uri.parse('$supabaseUrl/functions/v1/delete-images');

      // 전체 경로 생성 (사용자 ID + 폴더 경로 + 파일 이름)
      List<String> fullFilePaths = imageFilePaths
          .map((filePath) => '$userId/$folderPath/$filePath')
          .toList();

      // 삭제할 파일 경로를 Edge Function으로 전송
      final payload = jsonEncode({"filePaths": fullFilePaths});
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      try {
        final response = await http.post(
          edgeFunctionUrl,
          headers: headers,
          body: payload,
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final deletedFilePaths = responseBody['deletedFilePaths'] as List;

          if (deletedFilePaths.isEmpty) {
            throw Exception('No files were deleted');
          }
        } else {
          throw Exception(
              'Failed to delete files (status: ${response.statusCode}): ${response.body}');
        }
      } catch (e, stackTrace) {
        trackError(e, stackTrace, 'Exception in edgeFunction delete-images');
        debugErrorMessage(
            'Exception in edgeFunction delete-images: ${e.toString()}');
        throw Exception(
            'Exception in edgeFunction delete-images: ${e.toString()}');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteImages');
      debugErrorMessage('deleteImages exception: ${e.toString()}');
      throw Exception('deleteImages exception: ${e.toString()}');
    }
  }

  static Future<void> moveSelection(int categoryId, int oldCollectionId,
      int oldSelectionId, int newCollectionId) async {
    try {
      await _supabase
          .from('selections')
          .update({
            'category_id': categoryId,
            'collection_id': newCollectionId,
            'selection_id': null
          })
          .eq('collection_id', oldCollectionId)
          .eq('selection_id', oldSelectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in moveSelection');
      debugErrorMessage('moveSelection exception: ${e}');
      throw Exception('moveSelection exception: ${e}');
    }
  }

  static Future<void> selecting(int categoryId, int selectingCollectionId,
      SelectionModel selectedData) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      int _selectedCollectionId = selectedData.collectionId;
      int _selectedSelectionId = selectedData.selectionId;

      final selectedSelection = await _supabase
          .from('selections')
          .select()
          .eq('collection_id', _selectedCollectionId)
          .eq('selection_id', _selectedSelectionId)
          .single();

      if (selectedSelection['is_selecting'] == true) {
        final selectingSelection = await _supabase
            .from('selecting')
            .select('selected_collection_id, selected_selection_id')
            .eq('uuid', selectedSelection['selecting_uuid'])
            .single();

        _selectedCollectionId = selectingSelection['selected_collection_id'];
        _selectedSelectionId = selectingSelection['selected_selection_id'];
      }

      final selectedSelectionData = Map.of(selectedSelection);

      final newData = await _supabase
          .from('selections')
          .insert({
            'category_id': categoryId,
            'collection_id': selectingCollectionId,
            'selection_id': null,
            'owner_id': selectedSelectionData['owner_id'],
            'user_id': userId,
            'title': selectedSelectionData['title'],
            'description': selectedSelectionData['description'],
            'image_file_paths': selectedSelectionData['image_file_paths'],
            'keywords': selectedSelectionData['keywords'],
            'link': selectedSelectionData['link'],
            'items': selectedSelectionData['items'],
            'is_ordered': selectedSelectionData['is_ordered'],
            'is_selectable': selectedSelectionData['is_selectable'],
            'is_selecting': true,
          })
          .select()
          .single();

      await _supabase.from('selecting').update({
        'selected_collection_id': _selectedCollectionId,
        'selected_selection_id': _selectedSelectionId,
        'selected_user_id': selectedData.ownerId,
      }).eq('uuid', newData['selecting_uuid']);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in selecting');
      debugErrorMessage('selecting exception: ${e}');
      throw Exception('selecting exception: ${e}');
    }
  }

  static Future<void> report(int reportType, Map<String, int> reportedPostId,
      String reportReason) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int reportedUserId = int.parse(userIdString!);

      await _supabase.from('reports').insert({
        'report_type': reportType,
        'report_reason': reportReason,
        'reporter_user_id': reportedUserId,
        'reported_post_id': reportedPostId,
      });
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in report');
      debugErrorMessage('report exception: ${e}');
      throw Exception('report exception: ${e}');
    }
  }

  static Future<void> block(int blockedUserId) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int blockerUserId = int.parse(userIdString!);
      await _supabase.from('block').insert({
        'blocker_user_id': blockerUserId,
        'blocked_user_id': blockedUserId,
      });
      _blockedUserIds.add(blockedUserId);
      await DataService.reloadLocalData(blockedUserId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in block');
      debugErrorMessage('block exception: ${e}');
      throw Exception('block exception: ${e}');
    }
  }

  static Future<void> initializeBlockedIds() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      if (userIdString != null) {
        int userId = int.parse(userIdString);

        final responseData = await _supabase
            .from('block')
            .select('blocked_user_id')
            .eq('blocker_user_id', userId);

        _blockedUserIds = (responseData)
            .map((item) => item['blocked_user_id'] as int)
            .toList();

        print('Initial blocked users: $_blockedUserIds');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in initializeBlockedIds');
      debugErrorMessage('initializeBlockedIds exception: ${e}');
      throw Exception('initializeBlockedIds exception: ${e}');
    }
  }

  static Future<void> startSubscriptions() async {
    await myCollectionsSubscription();
  }

  static Future<void> stopSubscriptions() async {
    try {
      if (_myCollectionsChannel != null) {
        _supabase.removeChannel(_myCollectionsChannel!);
        print('listener canceled');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in stopSubscriptions');
      debugErrorMessage('stopSubscriptions exception: ${e}');
      throw Exception('stopSubscriptions exception: ${e}');
    }
  }

  static void debugErrorMessage(String? message) {
    print('$message');
  }
}
