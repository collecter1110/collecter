import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../../components/pop_up/toast.dart';
import '../model/collection_model.dart';
import '../model/selecting_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../provider/collection_provider.dart';
import '../provider/ranking_provider.dart';
import 'locator.dart';
import 'token_service.dart';

class ApiService {
  static final storage = FlutterSecureStorage();
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final authUser = _supabase.auth.currentUser;
  static StreamSubscription<dynamic>? _blockedUsersSubscription;
  static StreamSubscription<List<Map<String, dynamic>>>?
      _rankingCollectionsSubscription;
  static StreamSubscription<List<Map<String, dynamic>>>?
      _rankingSelectionsSubscription;
  static StreamSubscription<List<Map<String, dynamic>>>?
      _rankingUsersSubscription;
  static StreamSubscription<List<Map<String, dynamic>>>?
      _myCollectionsSubscription;
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

    if (exception is SocketException) {
      Toast.notify('네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.');
    } else if (exception is TimeoutException) {
      Toast.notify('요청 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.');
    } else if (exception is FormatException) {
      Toast.notify('데이터 형식 오류가 발생했습니다. 다시 시도해 주세요.');
    } else if (exception is PlatformException) {
      Toast.notify('플랫폼 오류가 발생했습니다. 설정을 확인해 주세요.');
    } else if (exception is HttpException) {
      Toast.notify('서버 요청 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    } else if (exception is AuthException) {
      Toast.notify('인증 오류가 발생했습니다. 다시 로그인해 주세요.');
    } else {
      Toast.notify('죄송합니다.\n현재 일시적인 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.');
    }
  }

  static Future<void> authListener() async {
    final authSubscription =
        _supabase.auth.onAuthStateChange.listen((data) async {
      try {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        print('Auth event: $event');

        switch (event) {
          case AuthChangeEvent.initialSession:
            break;
          case AuthChangeEvent.signedIn:
            print('Save initial token');
            if (session != null) {
              await TokenService.saveTokens(
                session.accessToken,
                session.refreshToken ?? '',
              );
            }
            break;
          case AuthChangeEvent.tokenRefreshed:
            if (session != null) {
              print('get refresh token');
              await TokenService.saveTokens(
                session.accessToken,
                session.refreshToken ?? '',
              );
            } else {
              print('refresh token expired');
              await TokenService.deleteStorageData();
            }
            break;
          case AuthChangeEvent.signedOut:
            print('log out');
            await TokenService.deleteStorageData();
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

  static Future<void> saveUserIdInStorage() async {
    try {
      String email = await ApiService.getEmailFromAuthentication();
      final response = await _supabase
          .from('userinfo')
          .select('user_id')
          .eq('email', email)
          .single();
      int userId = response['user_id'];
      await storage.write(key: 'USER_ID', value: userId.toString());
      print(userId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in saveUserIdInStorage');
      debugErrorMessage('saveUserIdInStorage exception: ${e}');
      throw Exception('saveUserIdInStorage exception: ${e}');
    }
  }

  static Future<String> getEmailFromAuthentication() async {
    try {
      if (authUser != null) {
        return authUser!.email!;
      } else {
        debugErrorMessage('No authenticated user found');
        throw Exception('No authenticated user found');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getEmailFromAuthentication');
      debugErrorMessage('getEmailFromAuthentication exception: ${e}');
      throw Exception('getEmailFromAuthentication exception: ${e}');
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
        return true;
      } else {
        return false;
      }
    } on AuthException catch (e, stackTrace) {
      if (e.message == 'User is banned') {
        Toast.notify(
            '3회 이상 신고로 계정이\n1주일간 정지되었습니다.\n문의 : contact.collect@gmail.com');
      }
      trackError(e, stackTrace, 'Exception in checkOtp');
      debugErrorMessage('checkOtp exception: ${e}');
      return false;
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
      String email = await getEmailFromAuthentication();
      await _supabase.from('userinfo').update({
        'name': userName,
        'description': userDescription,
      }).eq('email', email);
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
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
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

  static Future<void> deleteAllStorageImages() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      String userId = userIdString!.toString();

      final response = await _supabase.rpc('get_storage_files', params: {
        'user_id': userId,
      });

      if (response == null || response is! List) {
        print('파일 목록 가져오기 실패 또는 데이터가 비어 있습니다.');
        return;
      }

      final List<String> filesToRemove =
          List<String>.from(response.map((item) => item['file_name']));
      if (filesToRemove.isNotEmpty) {
        final deleteResponse =
            await _supabase.storage.from('images').remove(filesToRemove);

        if (deleteResponse == null) {
          print('파일 삭제 실패: ${deleteResponse}');
        } else {
          print('폴더 내 모든 파일 삭제 성공');
        }
      } else {
        print('삭제할 파일이 없습니다.');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteAllStorageImages');
      debugErrorMessage('deleteAllStorageImages exception: ${e}');
      throw Exception('deleteAllStorageImages exception: ${e}');
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
              'collection_id, selection_id, title, image_file_paths, keywords, owner_name, owner_id, is_selecting')
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
              'collection_id, selection_id, user_id, owner_id, title, description, image_file_paths, is_ordered, link, items, keywords, created_at, owner_name, is_selectable, is_selecting')
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
      final _completer = Completer<List<CollectionModel>>();
      List<CollectionModel>? _updatedCollections;

      final _initialRankingCollections = await _supabase
          .from('collections')
          .select()
          .eq('is_public', true)
          .order('like_num')
          .limit(10);

      List<int> _initialRankingCollectionIds =
          (_initialRankingCollections as List<dynamic>)
              .where((item) => !_blockedUserIds.contains(item['user_id']))
              .map((item) => item['id'] as int)
              .toList();

      _rankingCollectionsSubscription = _supabase
          .from('collections')
          .stream(primaryKey: ['id'])
          .inFilter('id', _initialRankingCollectionIds)
          .order('like_num')
          .limit(20)
          .listen((snapshot) {
            print('랭킹 컬렉션 callback');
            _updatedCollections = snapshot.map((item) {
              return CollectionModel.fromJson(item);
            }).toList();

            locator<RankingProvider>().updateRankingCollections =
                _updatedCollections!;

            if (!_completer.isCompleted) {
              _completer.complete(_updatedCollections!);
            }
          }, onError: (error, stackTrace) {
            trackError(error, stackTrace, 'Exception in getRankingCollections');
            debugErrorMessage('getRankingCollections exception: $error');
            if (!_completer.isCompleted) {
              _completer.completeError(error, stackTrace);
            }
          });

      return _completer.future;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingCollections');
      debugErrorMessage('getRankingCollections exception: ${e}');
      throw Exception('getRankingCollections exception: ${e}');
    }
  }

  static Future<List<SelectionModel>> getRankingSelections() async {
    try {
      final _completer = Completer<List<SelectionModel>>();
      List<SelectionModel>? updatedSelections;

      _rankingSelectionsSubscription = _supabase
          .from('selections')
          .stream(primaryKey: ['collection_id', 'selection_id'])
          .order('select_num')
          .limit(20)
          .listen((snapshot) {
            print('랭킹 셀렉션 callback');

            updatedSelections = snapshot.where((item) {
              return !_blockedUserIds.contains(item['user_id']) &&
                  item['is_selecting'] == false;
            }).map((item) {
              List? imageFilePaths = item['image_file_paths'] as List<dynamic>?;
              String? firstImagePath =
                  imageFilePaths != null && imageFilePaths.isNotEmpty
                      ? imageFilePaths.first as String
                      : null;

              return SelectionModel.fromJson({
                ...item,
              }, thumbFilePath: firstImagePath);
            }).toList();

            locator<RankingProvider>().updateRankingSelections =
                updatedSelections!;

            if (!_completer.isCompleted) {
              _completer.complete(updatedSelections!);
            }
          }, onError: (error, stackTrace) {
            trackError(error, stackTrace, 'Exception in getRankingSelections');
            debugErrorMessage('getRankingSelections exception: $error');
            if (!_completer.isCompleted) {
              _completer.completeError(error, stackTrace);
            }
          });

      return _completer.future;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingSelections');
      debugErrorMessage('getRankingSelections exception: ${e}');
      throw Exception('getRankingSelections exception: ${e}');
    }
  }

  static Future<List<UserInfoModel>> getRankingUsers() async {
    try {
      final _completer = Completer<List<UserInfoModel>>();
      List<UserInfoModel>? updatedUsers;
      _rankingUsersSubscription = _supabase
          .from('userinfo')
          .stream(primaryKey: ['user_id'])
          .order('created_at', ascending: false)
          .limit(10)
          .listen((snapshot) {
            print('랭킹 유저 callback');
            updatedUsers = snapshot
                .where(
                    (item) => !_blockedUserIds.contains(item['user_id'] as int))
                .map((item) {
              return UserInfoModel.fromJson(item);
            }).toList();

            locator<RankingProvider>().updateRankingUsers = updatedUsers!;

            if (!_completer.isCompleted) {
              _completer.complete(updatedUsers!);
            }
          }, onError: (error, stackTrace) {
            trackError(error, stackTrace, 'Exception in getRankingUsers');
            debugErrorMessage('getRankingUsers exception: $error');
            if (!_completer.isCompleted) {
              _completer.completeError(error, stackTrace);
            }
          });

      return _completer.future;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in getRankingUsers');
      debugErrorMessage('getRankingUsers exception: ${e}');
      throw Exception('getRankingUsers exception: ${e}');
    }
  }

  static Future<List<CollectionModel>> getCollections() async {
    try {
      final _completer = Completer<List<CollectionModel>>();
      List<CollectionModel>? _updatedCollections;
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      _myCollectionsSubscription = _supabase
          .from('collections')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .listen((snapshot) {
            print('내 콜렉션 callback');
            _updatedCollections = snapshot.map((item) {
              return CollectionModel.fromJson(item);
            }).toList();

            locator<CollectionProvider>().updateCollections =
                _updatedCollections!;

            if (!_completer.isCompleted) {
              _completer.complete(_updatedCollections!);
            }
          }, onError: (error, stackTrace) {
            trackError(error, stackTrace, 'Exception in getCollections');
            debugErrorMessage('getCollections exception: $error');
            if (!_completer.isCompleted) {
              _completer.completeError(error, stackTrace);
            }
          });

      return _completer.future;
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

  static Future<String> uploadAndGetImageFilePath(
    XFile xfile,
    String folderPath,
  ) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    try {
      String _fileName = path.basename(xfile.path);
      final String filePath = '$userId/$folderPath/$_fileName';
      File file = File(xfile.path);
      await _supabase.storage.from('images').upload(filePath, file);
      print('파일 업로드 성공: $_fileName');
      return _fileName;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in uploadAndGetImageFilePath');
      debugErrorMessage('uploadAndGetImageFilePath exception: ${e}');
      throw Exception('uploadAndGetImageFilePath exception: ${e}');
    }
  }

  static Future<void> copyImageFilePath(
    String sourceFolderPath,
    String destinationFolderPath,
    String fileName,
    int collectionId,
  ) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    try {
      final String sourcePath = '$userId/$sourceFolderPath/$fileName';
      final String destinationPath =
          '$userId/$destinationFolderPath/${collectionId}_$fileName';

      await _supabase.storage.from('images').copy(sourcePath, destinationPath);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in copyImageFilePath');
      debugErrorMessage('copyImageFilePath exception: ${e}');
      throw Exception('copyImageFilePath exception: ${e}');
    }
  }

  static Future<List<String>> uploadAndGetImageFilePaths(
      List<XFile> xfiles, String folderPath) async {
    List<String> _fileNames = [];

    try {
      final uploadFutures = xfiles.map((xfile) {
        return uploadAndGetImageFilePath(xfile, folderPath);
      }).toList();

      _fileNames = await Future.wait(uploadFutures);

      return _fileNames;
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in uploadAndGetImageFilePaths');
      debugErrorMessage('uploadAndGetImageFilePaths exception: ${e}');
      throw Exception('uploadAndGetImageFilePaths exception: ${e}');
    }
  }

  static Future<void> addCollection(String title, String? description,
      List<String>? tags, bool isPublic) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      await _supabase.from('collections').insert({
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
  ) async {
    try {
      List<Map<String, dynamic>> newKeywordEntries =
          keywords.map((keyword) => {'keyword_name': keyword}).toList();

      await _supabase
          .from('keywordinfo')
          .upsert(newKeywordEntries,
              onConflict: 'keyword_name', ignoreDuplicates: true)
          .select();

      final response = await _supabase
          .from('keywordinfo')
          .select()
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
      int collectionId,
      String title,
      String? description,
      String? imageFilePath,
      List<String>? tags,
      bool isPublic) async {
    try {
      await _supabase.from('collections').update({
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
    String storageFolderName,
    List<String> imageFilePaths,
  ) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      List<String> fullFilePaths = [];

      fullFilePaths = imageFilePaths
          .map((filePath) => '$userId/$storageFolderName/$filePath')
          .toList();

      final response =
          await _supabase.storage.from('images').remove(fullFilePaths);

      if (response.isEmpty) {
        print('Deleting images from paths: $fullFilePaths');
        print('Failed to delete storage images');
      }
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in deleteStorageImages');
      debugErrorMessage('deleteStorageImages exception: ${e}');
      throw Exception('deleteStorageImages exception: ${e}');
    }
  }

  static Future<void> moveSelection(
      int oldCollectionId, int oldSelectionId, int newCollectionId) async {
    try {
      await _supabase
          .from('selections')
          .update({'collection_id': newCollectionId, 'selection_id': null})
          .eq('collection_id', oldCollectionId)
          .eq('selection_id', oldSelectionId);
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in moveSelection');
      debugErrorMessage('moveSelection exception: ${e}');
      throw Exception('moveSelection exception: ${e}');
    }
  }

  static Future<void> selecting(
      int selectingCollectionId, SelectionModel selectedData) async {
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
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in block');
      debugErrorMessage('block exception: ${e}');
      throw Exception('block exception: ${e}');
    }
  }

  static Future<void> restartSubscriptions(userId) async {
    try {
      _blockedUsersSubscription = _supabase
          .from('block')
          .stream(primaryKey: ['id'])
          .eq('blocker_user_id', userId)
          .listen((snapshot) async {
            print('Blocked users updated');

            _blockedUserIds =
                snapshot.map((item) => item['blocked_user_id'] as int).toList();
            try {
              await getCollections();
              await getRankingCollections();
              await getRankingSelections();
              await getRankingUsers();
            } catch (innerError, innerStackTrace) {
              trackError(innerError, innerStackTrace,
                  'Exception during data updates in restartSubscriptions');
              debugErrorMessage(
                  'Data update exception in restartSubscriptions: $innerError');
            }
          }, onError: (error, stackTrace) {
            trackError(error, stackTrace,
                'Exception in stream subscription of restartSubscriptions');
            debugErrorMessage(
                'Stream subscription exception in restartSubscriptions: $error');
          });
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in restartSubscriptions');
      debugErrorMessage('restartSubscriptions exception: ${e}');
      throw Exception('restartSubscriptions exception: ${e}');
    }
  }

  static Future<void> disposeSubscriptions() async {
    try {
      await _blockedUsersSubscription?.cancel();
      await _rankingCollectionsSubscription?.cancel();
      await _rankingSelectionsSubscription?.cancel();
      await _rankingUsersSubscription?.cancel();
      await _myCollectionsSubscription?.cancel();
      print('listener canceled');
    } catch (e, stackTrace) {
      trackError(e, stackTrace, 'Exception in disposeSubscriptions');
      debugErrorMessage('disposeSubscriptions exception: ${e}');
      throw Exception('disposeSubscriptions exception: ${e}');
    }
  }

  static void debugErrorMessage(String? message) {
    print('$message');
  }
}
