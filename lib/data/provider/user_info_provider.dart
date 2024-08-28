import 'package:flutter/material.dart';

import '../model/user_info_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo; // nullable 타입으로 선언

  UserInfoModel? get userInfo => _userInfo;

  Future<void> fetchUserInfo() async {
    try {
      if (_userInfo != null) {
        return;
      }

      final results = await ApiService.getUserInfo();
      _userInfo = results;
      print('fetchUserInfo');
      notifyListeners();
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }
}
