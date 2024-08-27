import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/pop_up/error_messege_toast.dart';

class ApiService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<String?> getEmailFromToken() async {
    final user = _supabase.auth.currentUser;

    if (user != null) {
      final email = user.email;
      print('User email: $email');
      return email;
    } else {
      return null;
    }
  }

  static Future<bool> checkUserInfoExist(String email) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select('name') // 'name' 속성만 선택
          .eq('email', email) // 특정 이메일 조건
          .maybeSingle(); // 결과가 단일 항목일 때 사용

      if (response != null) {
        final name = response['name'];
        print('User name: $name');
        return true;
      } else {
        print('Membership was registered, but userInfo was not entered.');
        return false;
      }
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('checkEmailExist exception: $e');
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

  static Future<bool> updateUserInfo(
      String email, String userName, String userDescription) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .update({
            'name': userName,
            'description': userDescription,
          })
          .eq('email', email)
          .select();
      print(response);
      if (response.isEmpty) {
        print('No user found with the given email');
        return false;
      } else {
        return true;
      }
    } on AuthException catch (e) {
      handleError(e.statusCode, e.message);
      return false;
    } catch (e) {
      print('updateUserInfo exception: $e');
      return false;
    }
  }

  // static Future<bool> signUp(String email, String userName, String imageUrl,
  //     String description) async {
  //   try {
  //     final AuthResponse response = await _supabase.auth.(
  //       email: email,
  //       password: 'kgh753951',
  //       data: {
  //         'user_name': 'test_name',
  //         'image_url': 'test_imageUrl',
  //         'message': 'test_message',
  //       },
  //     );
  //     if (response.user != null) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } on AuthException catch (e) {
  //     handleError(e.statusCode, e.message);
  //     return false;
  //   } catch (e) {
  //     print('signUp exception: $e');
  //     return false;
  //   }
  // }

  // static Future<void> checkUserStatus() async {
  //   try {
  //     final response = await _supabase.auth.getUser();

  //     if (response.user != null && response.user!.emailConfirmedAt != null) {
  //       print('Email is confirmed!');
  //     } else {
  //       print('Email is not confirmed.');
  //     }
  //   } on AuthException catch (e) {
  //     print('Email verified Failed: ${e.message}');
  //   } catch (e) {
  //     print('An unexpected error occurred: $e');
  //   }
  // }

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

  static void handleError(String? statusCode, String? message) {
    if (statusCode == '400') {
      print('Bad Request - 400: 잘못된 요청입니다.');
    } else if (statusCode == '401') {
      print('Unauthorized - 401: 인증이 필요합니다.');
    } else if (statusCode == '403') {
      print('Forbidden - 403: 접근이 금지되었습니다.');
    } else if (statusCode == '404') {
      print('Not Found - 404: 요청한 리소스를 찾을 수 없습니다.');
    } else if (statusCode == '500') {
      ErrorMessegeToast.error();
      print('Internal Server Error - 500: 서버에 문제가 발생했습니다.');
    } else if (statusCode == '502') {
      ErrorMessegeToast.error();
      print('Bad Gateway - 502: 잘못된 게이트웨이입니다.');
    } else if (statusCode == '503') {
      ErrorMessegeToast.error();
      print('Service Unavailable - 503: 서비스가 일시적으로 이용 불가능합니다.');
    } else if (statusCode == '504') {
      ErrorMessegeToast.error();
      print('Gateway Timeout - 504: 게이트웨이 응답 시간이 초과되었습니다.');
    } else {
      print('Unknown error: $message');
    }
  }
}
