import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/user_info_model.dart';
import '../services/api_service.dart';

class UserInfoProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  UserInfoModel? _userInfo;
  UserInfoModel? _otherUserInfo;

  int? _collectionNum;
  int? _selectingNum;
  int? _selectedNum;

  List<UserInfoModel>? _searchUsers;
  String? _currentSearchText;

  ConnectionState get state => _state;
  UserInfoModel? get userInfo => _userInfo;
  UserInfoModel? get otherUserInfo => _otherUserInfo;
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
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }

  Future<void> fetchUserInfo() async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));
      _userInfo = await ApiService.getUserInfo();
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch collections: $e');
    } finally {
      _state = ConnectionState.done;
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
      _searchUsers = await ApiService.searchUsers(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }
}
