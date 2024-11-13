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

  Future<void> getRankingCollectionData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));

    try {
      await fetchRankingCollections();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getRankingSelectionData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));

    try {
      await fetchRankingSelections();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getRankingUserData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));

    try {
      await fetchRankingUsers();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRankingCollections() async {
    try {
      _rankingCollections = await ApiService.getRankingCollections();
      print('_rankingCollections');
    } catch (e) {
      print('Failed to fetchRankingCollections: $e');
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      _rankingSelections = await ApiService.getRankingSelections();
      print('_rankingSelections');
    } catch (e) {
      print('Failed to fetchRankingSelections: $e');
    }
  }

  Future<void> fetchRankingUsers() async {
    try {
      _rankingUsers = await ApiService.getRankingUsers();
      print('_rankingUsers');
    } catch (e) {
      print('Failed to rankingUsers: $e');
    }
  }
}
