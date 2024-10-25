import 'dart:async';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
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

  static Future<void> authListener() async {
    final authSubscription =
        _supabase.auth.onAuthStateChange.listen((data) async {
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
              session.accessToken ?? '',
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
    } catch (e) {
      throw Exception('updateUserInfo exception: ${e}');
    }
  }

  static Future<String> getEmailFromAuthentication() async {
    try {
      if (authUser != null) {
        return authUser!.email!;
      } else {
        handleError('', 'No authenticated user found');
        throw Exception('No authenticated user found');
      }
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      print('checkUserInfoExist : $e');
      throw Exception('An unexpected error occurred');
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('checkEmailExist exception: $e');
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('sendOtp exception: $e');
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('checkOtp exception: $e');
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('checkEmailExist exception: $e');
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
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
    } catch (e) {
      throw Exception('updateUserInfo exception: ${e}');
    }
  }

  ///앱 로그아웃 시 로컬스토리지 데이터 삭제
  ///앱 access token 만료시 데이터 삭제

  static Future<void> emailLogin(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );

      print('OTP sent to $email');
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
    } catch (e) {
      print('sendOtp exception: $e');
    }
  }

  static Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
    } catch (e) {
      print('sendOtp exception: $e');
    }
  }

  static Future<void> deleteAuthUser() async {
    final userUuid = authUser?.id;

    if (userUuid == null) {
      print('사용자가 로그인되어 있지 않습니다.');
      return;
    }
    await _supabase
        .rpc('delete_user_by_owner', params: {'user_uuid': userUuid});
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
    } catch (error) {
      Toast.error();
      throw Exception('An unexpected error occurred: $error');
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
    } catch (e) {
      Toast.error();
      throw Exception('delete all storage images exception: $e');
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
    } on AuthException catch (e) {
      Toast.error();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      Toast.error();
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      Toast.error();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      Toast.error();
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      Toast.error();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      Toast.error();
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      Toast.error();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      Toast.error();
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'getCollectionTitle error');
      throw Exception('An unexpected error occurred: $e');
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
              .map((item) => item['id'] as int)
              .toList();

      _supabase
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
          });

      return _completer.future;
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'get ranking collection error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<SelectionModel>> getRankingSelections() async {
    try {
      final completer = Completer<List<SelectionModel>>();
      List<SelectionModel>? updatedSelections;

      _supabase
          .from('selections')
          .stream(primaryKey: ['collection_id', 'selection_id'])
          .order('select_num')
          .limit(20)
          .listen((snapshot) {
            print('listen');

            updatedSelections = snapshot.where((item) {
              return item['is_selecting'] == false;
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

            if (!completer.isCompleted) {
              completer.complete(updatedSelections!);
            }
          });

      return completer.future;
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'get ranking selection error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<UserInfoModel>> getRankingUsers() async {
    try {
      final completer = Completer<List<UserInfoModel>>();
      List<UserInfoModel>? updatedUsers;
      _supabase
          .from('userinfo')
          .stream(primaryKey: ['user_id'])
          .order('created_at', ascending: false)
          .limit(10)
          .listen((snapshot) {
            updatedUsers = snapshot.map((item) {
              return UserInfoModel.fromJson(item);
            }).toList();

            locator<RankingProvider>().updateRankingUsers = updatedUsers!;

            if (!completer.isCompleted) {
              completer.complete(updatedUsers!);
            }
          });

      return completer.future;
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'get ranking collection error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<CollectionModel>> getCollections() async {
    try {
      final _completer = Completer<List<CollectionModel>>();
      List<CollectionModel>? _updatedCollections;
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      _supabase
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
          });

      return _completer.future;
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'getCollections error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<CollectionModel>> getLikeCollections() async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    final response = await _supabase
        .from('likes')
        .select('collections(*)')
        .eq('user_id', userId);

    final List<CollectionModel> likeCollections = response
        .map((item) => CollectionModel.fromJson(item['collections']))
        .toList();

    return likeCollections;
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'getCollectionDetail error');
      throw Exception('An unexpected error occurred: $e');
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
    } catch (e) {
      handleError('', 'upload image error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<void> copyImageFilePath(
    String sourceFolderPath,
    String destinationFolderPath,
    String fileName,
  ) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    try {
      final String sourcePath = '$userId/$sourceFolderPath/$fileName';
      final String destinationPath = '$userId/$destinationFolderPath/$fileName';

      await _supabase.storage.from('images').copy(sourcePath, destinationPath);
    } catch (e) {
      handleError('', 'copy image error');
      throw Exception('An unexpected error occurred: $e');
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
    } on SocketException catch (e) {
      handleError('', 'Network error: ${e.message}');
      throw Exception('Network error occurred: ${e.message}');
    } catch (e) {
      handleError('', 'uploadImages error: $e');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'add collections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'addSelections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'addKeywords error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> actionLike(int collectionId) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    await _supabase.from('likes').insert({
      'user_id': userId,
      'collection_id': collectionId,
    });
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'edit collections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'edit selections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'edit userInfo error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> actionUnlike(int collectionId) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);
    await _supabase
        .from('likes')
        .delete()
        .eq('user_id', userId)
        .eq('collection_id', collectionId);
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'searchCollectionsByKeyword error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'searchCollectionsByTag error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'get search selections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'get search users error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<UserInfoModel> getOtherUserInfo(int userId) async {
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
        Toast.error();
        throw Exception('Response code error <getUserInfo>');
      }
    } on AuthException catch (e) {
      Toast.error();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      Toast.error();
      handleError('', 'getOtherUserInfo error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'getUsersCollections error');
      throw Exception('An unexpected error occurred: $e');
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
    } catch (e) {
      handleError('', 'deleteCollection error');
      print('Failed to delete data: $e');
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
    } catch (e) {
      handleError('', 'deleteSelection error');
      print('Failed to delete selection data: $e');
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
    } catch (e) {
      handleError('', 'deleteStorageImages error');
      print('Failed to delete storage image: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'moveSelections error');
      throw Exception('An unexpected error occurred: $e');
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
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'moveSelections error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static void handleError(String? statusCode, String? message) {
    Toast.error();
    if (statusCode == '400') {
      print('Bad Request - 400: 잘못된 요청입니다.');
    } else if (statusCode == '401') {
      print('Unauthorized - 401: 인증이 필요합니다.');
    } else if (statusCode == '403') {
      print('Forbidden - 403: 접근이 금지되었습니다.');
    } else if (statusCode == '404') {
      print('Not Found - 404: 요청한 리소스를 찾을 수 없습니다.');
    } else if (statusCode == '500') {
      print('Internal Server Error - 500: 서버에 문제가 발생했습니다.');
    } else if (statusCode == '502') {
      print('Bad Gateway - 502: 잘못된 게이트웨이입니다.');
    } else if (statusCode == '503') {
      print('Service Unavailable - 503: 서비스가 일시적으로 이용 불가능합니다.');
    } else if (statusCode == '504') {
      print('Gateway Timeout - 504: 게이트웨이 응답 시간이 초과되었습니다.');
    } else {
      print('Unknown error: $message');
    }
  }
}
