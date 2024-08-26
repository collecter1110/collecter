import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<bool> checkEmailExist(String email) async {
    try {
      final response = await _supabase
          .from('userinfo')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      return response == null;
    } catch (e) {
      print('Error fetching user data: $e');
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
    } catch (e) {
      print('invaild email address: $e');
      return false;
    }
  }

  static Future<bool> signUp(String email) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: 'kgh753951',
        data: {
          'user_name': 'test_name',
          'image_url': 'test_imageUrl',
          'message': 'test_message',
        },
      );

      if (response.user != null) {
        print('succeed');
        return true;
      } else {
        print('fail');
        return false;
      }
    } on AuthException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
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
      print('OTP number $otp');
      if (response.user != null) {
        print('OTP verified success');
        return true;
      } else {
        print('OTP verified Failed');
        return false;
      }
    } catch (e) {
      print('Error verify OTP: $e');

      return false;
    }
  }

  // static Future<bool> signup(String email, String password, String name,
  //     String imageUrl, String description) async {
  //   try {
  //     final AuthResponse response = await _supabase.auth.signUp(
  //       email: email,
  //       password: password,
  //       data: {
  //         'user_name': name,
  //         'image_url': imageUrl,
  //         'discription': description,
  //       },
  //     );

  //     if (response.user != null) {
  //       checkUserStatus();
  //       return true;
  //     } else {
  //       print('Sign Up Failed');
  //       return false;
  //     }
  //   } on AuthException catch (e) {
  //     print('Sign Up Failed: ${e.message}');
  //     return false;
  //   } catch (e) {
  //     print('An unexpected error occurred: $e');
  //     return false;
  //   }
  // }

  static Future<void> checkUserStatus() async {
    try {
      final response = await _supabase.auth.getUser();

      if (response.user != null && response.user!.emailConfirmedAt != null) {
        print('Email is confirmed!');
      } else {
        print('Email is not confirmed.');
      }
    } on AuthException catch (e) {
      print('Email verified Failed: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  static Future<void> login(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('login Successful');
      } else {
        print('login Failed');
      }
    } on AuthException catch (e) {
      print('Sign Up Failed: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
}
