import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

import '../../components/pop_up/toast.dart';
import '../model/collection_model.dart';
import '../model/selecting_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';
import '../provider/ranking_provider.dart';
import 'locator.dart';

class ApiService {
  static final storage = FlutterSecureStorage();
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final authUser = _supabase.auth.currentUser;

// final authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
//   final AuthChangeEvent event = data.event;
//   final Session? session = data.session;

//   print('event: $event, session: $session');

//   switch (event) {
//     case AuthChangeEvent.initialSession:
//     // handle initial session
//     case AuthChangeEvent.signedIn:
//     // handle signed in
//     case AuthChangeEvent.signedOut:
//     // handle signed out
//     case AuthChangeEvent.passwordRecovery:
//     // handle password recovery
//     case AuthChangeEvent.tokenRefreshed:
//     // handle token refreshed
//     case AuthChangeEvent.userUpdated:
//     // handle user updated
//     case AuthChangeEvent.userDeleted:
//     // handle user deleted
//     case AuthChangeEvent.mfaChallengeVerified:
//     // handle mfa challenge verified
//   }
// });

  static Future<bool> checkAccessToken() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null || session.accessToken.isEmpty) {
        print('No Token');
        return false;
      }
      final userResponse = await Supabase.instance.client.auth.getUser();

      if (userResponse.user == null) {
        print('Token expired or invalid');
        return false;
      }
      return true;
    } catch (e) {
      print('checkAccessToken: $e');
      handleError('', 'checkAccessToken error');
      return false;
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

  static Future<bool> checkUserEmailInUserInfo() async {
    try {
      String email = await getEmailFromAuthentication();
      final response = await _supabase
          .from('userinfo')
          .select('name') // 'name' 속성만 선택
          .eq('email', email) // 특정 이메일 조건
          .maybeSingle(); // 결과가 단일 항목일 때 사용

      if (response != null) {
        if (response['name'] != null) {
          return true;
        } else {
          print('Need user info');
          return false;
        }
      } else {
        print('Membership was registered, but userInfo was not entered.');
        return false;
      }
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('checkUserInfoExist : $e');
      return false;
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
        writeUserIdToStorage();
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

  static Future<void> updateUserInfo(
      String userName, String userDescription) async {
    try {
      String email = await getEmailFromAuthentication();
      final response = await _supabase
          .from('userinfo')
          .update({
            'name': userName,
            'description': userDescription,
          })
          .eq('email', email)
          .select();
      if (response.isNotEmpty) {
      } else {
        throw Exception('User information not saved');
      }
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

  static Future<void> writeUserIdToStorage() async {
    try {
      final userUuid = authUser!.id;
      final response = await _supabase
          .from('userinfo')
          .select('user_id')
          .eq('id', userUuid)
          .single();
      int userId = response['user_id'];
      await storage.write(key: 'USER_ID', value: userId.toString());
      print(userId);
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
    } catch (e) {
      print('writeUserIdToStorage exception: $e');
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

  static Future<UserOverviewModel> getUserOverview() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      final responseData = await _supabase
          .from('useroverview')
          .select('label_ids, collection_num, selecting_num, selected_num')
          .eq('user_id', userId)
          .single();

      UserOverviewModel userOverviewModel =
          UserOverviewModel.fromJson(responseData);
      return Future.value(userOverviewModel);
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
              'collection_id, selection_id, title, image_file_paths, keywords, owner_name, owner_id')
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
              'collection_id, selection_id, user_id, owner_id, title, description, image_file_paths, is_ordered, link, items, keywords, created_at, owner_name, is_select')
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
          .listen((snapshot) {
            print('callback');
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
          .eq('is_selecting', false)
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

              // updatedSelections = snapshot.map((item) {
              //   List? imageFilePaths = item['image_file_paths'] as List<dynamic>?;
              //   String? firstImagePath =
              //       imageFilePaths != null && imageFilePaths.isNotEmpty
              //           ? imageFilePaths.first as String
              //           : null;

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
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final responseData = await _supabase.from('collections').select('''
        id, 
        title, 
        image_file_path, 
        user_id,
        user_name, 
        primary_keywords, 
        selection_num,
        is_private
        ''').eq('user_id', userId);

      List<CollectionModel> collections = responseData.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();

      return collections;
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
    final response = await Supabase.instance.client
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
        is_private
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
      List<String>? tags, bool isPrivate) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      await Supabase.instance.client.from('collections').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'tags': tags,
        'is_private': isPrivate,
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
      bool isPrivate) async {
    final userIdString = await storage.read(key: 'USER_ID');
    int userId = int.parse(userIdString!);

    try {
      await Supabase.instance.client.from('selections').insert({
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
        'is_select': isPrivate,
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

      await Supabase.instance.client
          .from('keywordinfo')
          .upsert(newKeywordEntries,
              onConflict: 'keyword_name', ignoreDuplicates: true)
          .select();

      final response = await Supabase.instance.client
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
    await Supabase.instance.client.from('likes').insert({
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
      bool isPrivate) async {
    try {
      await _supabase.from('collections').update({
        'title': title,
        'description': description,
        'image_file_path': imageFilePath,
        'tags': tags,
        'is_private': isPrivate,
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
    bool isPrivate,
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
            'is_select': isPrivate,
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
    await Supabase.instance.client
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
        is_private
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

  static Future<void> deleteCollection(int collectionId, int userId) async {
    try {
      final collectionData = await _supabase
          .from('collections')
          .select('selection_num')
          .eq('id', collectionId)
          .single();

      int selectionNum = collectionData['selection_num'];

      if (selectionNum != 0) {
        final selectionImageFilePaths = await _supabase
            .from('selections')
            .select('image_file_paths')
            .eq('collection_id', collectionId)
            .eq('owner_id', userId);

        List<String> imageFilePaths = [];

        for (var item in selectionImageFilePaths) {
          if (item['image_file_paths'] != null) {
            imageFilePaths.addAll(List<String>.from(item['image_file_paths']));
          }
        }
        await deleteStorageImages('selections', imageFilePaths);
      }
      await _supabase.from('collections').delete().eq('id', collectionId);
    } catch (e) {
      handleError('', 'deleteCollection error');
      print('Failed to delete data: $e');
    }
  }

  static Future<void> deleteSelection(
      int collectionId, int selectionId, int ownerId, int userId) async {
    try {
      if (ownerId == userId) {
        final selectionImageFilePaths = await _supabase
            .from('selections')
            .select('image_file_paths')
            .eq('collection_id', collectionId)
            .eq('selection_id', selectionId)
            .single();

        if (selectionImageFilePaths['image_file_paths'] != null) {
          List<String> imageFilePaths = [];
          imageFilePaths =
              List<String>.from(selectionImageFilePaths['image_file_paths']);
          await deleteStorageImages('selections', imageFilePaths);
        }
      }
      await _supabase
          .from('selections')
          .delete()
          .eq('collection_id', collectionId)
          .eq('selection_id', selectionId);
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
            'is_select': selectedSelectionData['is_select'],
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
