import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/user_info_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo;
  UserInfoModel? _otherUserInfo;

  int? _collectionNum;
  int? _selectingNum;
  int? _selectedNum;

  UserInfoModel? get userInfo => _userInfo;
  UserInfoModel? get otherUserInfo => _otherUserInfo;
  int? get collectionNum => _collectionNum;
  int? get selectingNum => _selectingNum;
  int? get selectedNum => _selectedNum;

  Future<void> fetchUserInfo() async {
    try {
      _userInfo = await ApiService.getUserInfo();
    } catch (e) {
      print('Failed to fetch collections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchOtherUserInfo(int userId) async {
    try {
      _otherUserInfo = await ApiService.getOtherUserInfo(userId);
    } catch (e) {
      print('Failed to fetch other user info: $e');
    } finally {}
  }
}
