import 'package:flutter/material.dart';

import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo;
  UserOverviewModel? _userOverview;
  int? _selectingNum;
  int? _selectedNum;
  List<int>? _userLabelIds;

  UserInfoModel? get userInfo => _userInfo;
  List<int>? get userLabelIds => _userLabelIds;
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
    _selectingNum = _userOverview!.selectingNum;
    _selectedNum = _userOverview!.selectedNum;
    _userLabelIds = _userOverview!.labels;
    // for (var timeStampedData in _userOverview!.selectingProperties ?? []) {
    //   for (var createdTimeData in timeStampedData.times) {
    //     for (var property in createdTimeData.properties) {
    //       print('Selected Collection ID: ${property.selectedCollectionId}');
    //       print('Selected Selection ID: ${property.selectedSelectionId}');
    //       print('Selected User ID: ${property.selectedUserId}');
    //       print('Selecting Collection ID: ${property.selectingCollectionId}');
    //       print('Selecting User ID: ${property.selectingUserId}');
    //       print('Selecting Selection ID: ${property.selectingSelectionId}');
    //     }
    //   }
    // }

    // _selectingNum = _userOverview?.selectingProperties?.length ?? 0;
  }
}
