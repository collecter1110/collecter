import 'package:flutter/material.dart';

import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo;
  UserOverviewModel? _userOverview;
  List<int>? _userLabelIds;

  UserInfoModel? get userInfo => _userInfo;
  UserOverviewModel? get userOverview => _userOverview;
  List<int>? get userLabelIds => _userLabelIds;

  Future<void> fetchUserInfo() async {
    try {
      if (_userInfo != null) {
        return;
      }
      final resultUserOverview = await ApiService.getUserOverview();
      final resultUserInfo = await ApiService.getUserInfo();
      _userInfo = resultUserInfo;
      _userOverview = resultUserOverview;
      _userLabelIds = resultUserOverview.labels;
      print('fetchUserInfo');
      notifyListeners();
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }
}
