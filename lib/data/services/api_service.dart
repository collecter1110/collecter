import 'dart:async';
import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/pop_up/error_messege_toast.dart';
import '../model/collection_model.dart';
import '../model/selection_detail_model.dart';
import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';

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
          .select('name, email, description, image_file_path')
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
      ErrorMessegeToast();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      ErrorMessegeToast();
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<UserOverviewModel> getUserOverview() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      final responseData = await _supabase
          .from('useroverview')
          .select('label_ids, selecting_num, selected_num')
          .eq('user_id', userId)
          .single();

      UserOverviewModel userOverviewModel =
          UserOverviewModel.fromJson(responseData);
      return Future.value(userOverviewModel);
    } on AuthException catch (e) {
      ErrorMessegeToast();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      ErrorMessegeToast();
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<SelectingModel>> getSelectModels(String properties) async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final responseData = await _supabase
          .from('selectingview')
          .select(properties)
          .eq('user_id', userId)
          .single();
      print('getSelectModel');
      print(responseData);
      List<dynamic> jsonDataList = responseData[properties];

      List<SelectingModel> selectingModelList =
          jsonDataList.map((item) => SelectingModel.fromJson(item)).toList();

      return Future.value(selectingModelList);
    } on AuthException catch (e) {
      ErrorMessegeToast();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      ErrorMessegeToast();
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<SelectionDetailModel> getSelectionDetails(
      int collectionId, int selectionId, int userId) async {
    try {
      final responseData = await _supabase
          .from('selections')
          .select(
              'owner_id, selection_name, selection_description, image_file_path, is_ordered, selection_link, items, keywords, created_at, owner_name')
          .eq('collection_id', collectionId)
          .eq('selection_id', selectionId)
          .eq('user_id', userId)
          .single();

      print(responseData);
      SelectionDetailModel selectionDetailModel =
          SelectionDetailModel.fromJson(responseData);

      return selectionDetailModel;
    } on AuthException catch (e) {
      ErrorMessegeToast();
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      ErrorMessegeToast();
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<List<CollectionModel>> getCollections() async {
    try {
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);

      final responseData = await _supabase
          .from('collections')
          .select(
              'id, title, description, created_at,image_file_path, tags, user_name, primary_keywords, selection_num')
          .eq('user_id', userId);

      List<CollectionModel> selectionDetailModel =
          responseData.map((item) => CollectionModel.fromJson(item)).toList();

      return selectionDetailModel;
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      handleError('', 'getCollections error');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static void handleError(String? statusCode, String? message) {
    ErrorMessegeToast.error();
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
