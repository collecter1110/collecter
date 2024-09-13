import 'package:flutter/material.dart';

import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo;
  UserOverviewModel? _userOverview;
  int? _collectionNum;
  int? _selectingNum;
  int? _selectedNum;
  List<int>? _userLabelIds;
  UserInfoModel? get userInfo => _userInfo;
  List<int>? get userLabelIds => _userLabelIds;
  int get collectionNum => _collectionNum ?? 0;
  int get selectingNum => _selectingNum ?? 0;
  int get selectedNum => _selectedNum ?? 0;

  Future<void> getUsersData() async {
    try {
      if (_userInfo != null) {
        return;
      }
      await fetchUserInfo();
      await fetchUserOverview();
      print('fetchUserInfo');
      notifyListeners();
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }

  Future<void> fetchUserInfo() async {
    _userInfo = await ApiService.getUserInfo();
  }

  Future<void> fetchUserOverview() async {
    _userOverview = await ApiService.getUserOverview();
    _collectionNum = _userOverview!.collectionNum;
    _selectingNum = _userOverview!.selectingNum;
    _selectedNum = _userOverview!.selectedNum;
    _userLabelIds = _userOverview!.labels;
  }
}
