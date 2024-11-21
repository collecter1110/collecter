import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_service.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveConfigs(String supabaseUrl) async {
    await _storage.write(key: 'SUPABASE_URL', value: supabaseUrl);
  }

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'ACCESS_TOKEN', value: accessToken);
    await _storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'ACCESS_TOKEN');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'REFRESH_TOKEN');
  }

  static Future<void> deleteStorageData() async {
    await _storage.deleteAll();
    await ApiService.stopSubscriptions();
  }
}
