import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/user_info_model.dart';
import '../model/user_overview_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  UserInfoModel? _userInfo;
  UserOverviewModel? _userOverview;
  int? _collectionNum;
  int? _selectingNum;
  int? _selectedNum;
  List<int>? _userLabelIds;
  List<UserInfoModel>? _searchUsers;
  String? _currentSearchText;

  ConnectionState get state => _state;
  UserInfoModel? get userInfo => _userInfo;
  List<int>? get userLabelIds => _userLabelIds;
  int? get collectionNum => _collectionNum;
  int? get selectingNum => _selectingNum;
  int? get selectedNum => _selectedNum;
  List<UserInfoModel>? get searchUsers => _searchUsers;

  Future<void> getUsersData() async {
    try {
      if (_userInfo != null) {
        return;
      }
      await fetchUserInfo();
      await fetchUserOverview();
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }

  Future<void> fetchUserInfo() async {
    _userInfo = await ApiService.getUserInfo();
    notifyListeners();
  }

  Future<void> fetchUserOverview() async {
    _userOverview = await ApiService.getUserOverview();
    _collectionNum = _userOverview!.collectionNum;
    _selectingNum = _userOverview!.selectingNum;
    _selectedNum = _userOverview!.selectedNum;
    _userLabelIds = _userOverview!.labels;
    notifyListeners();
  }

  Future<void> getSearchUsers(String searchText) async {
    try {
      if (_currentSearchText != searchText) {
        await fetchSearchUsers(searchText);
      }
      _currentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> fetchSearchUsers(String searchText) async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));
      _searchUsers = await ApiService.searchUsers(searchText);
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }
}
