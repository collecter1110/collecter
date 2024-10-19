import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class RankingProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _rankingCollections;
  List<SelectionModel>? _rankingSelections;
  List<UserInfoModel>? _rankingUsers;

  ConnectionState get state => _state;

  List<CollectionModel>? get rankingCollections => _rankingCollections;
  List<SelectionModel>? get rankingSelections => _rankingSelections;
  List<UserInfoModel>? get rankingUsers => _rankingUsers;

  set updateRankingCollections(List<CollectionModel> updateRankingCollection) {
    _rankingCollections = updateRankingCollection;

    notifyListeners();
  }

  set updateRankingSelections(List<SelectionModel> updateRankingSelections) {
    _rankingSelections = updateRankingSelections;

    notifyListeners();
  }

  set updateRankingUsers(List<UserInfoModel> updateRankingUsers) {
    _rankingUsers = updateRankingUsers;

    notifyListeners();
  }

  Future<void> getRankingCollectionData() async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));
      await fetchRankingCollections();
    } catch (e) {
      _state = ConnectionState.none;
    }
  }

  Future<void> getRankingSelectionData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));
    try {
      await fetchRankingSelections();
    } catch (e) {
      _state = ConnectionState.none;
    }
  }

  Future<void> getRankingUserData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));
    try {
      await fetchRankingUsers();
    } catch (e) {
      _state = ConnectionState.none;
    }
  }

  Future<void> fetchRankingCollections() async {
    try {
      if (_rankingCollections != null) {
        return;
      }
      _rankingCollections = await ApiService.getRankingCollections();
      print('get ranking collections');
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch ranking collections: $e');
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      if (_rankingSelections != null) {
        return;
      }
      _rankingSelections = await ApiService.getRankingSelections();
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> fetchRankingUsers() async {
    try {
      if (_rankingUsers != null) {
        return;
      }
      _rankingUsers = await ApiService.getRankingUsers();
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }
}
