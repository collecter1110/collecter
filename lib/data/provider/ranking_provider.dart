import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class RankingProvider with ChangeNotifier {
  List<CollectionModel>? _rankingCollections;
  List<SelectionModel>? _rankingSelections;
  List<UserInfoModel>? _rankingUsers;

  List<CollectionModel>? get rankingCollections => _rankingCollections;
  List<SelectionModel>? get rankingSelections => _rankingSelections;
  List<UserInfoModel>? get rankingUsers => _rankingUsers;

  Future<void> fetchRankingCollections() async {
    try {
      _rankingCollections = await ApiService.getRankingCollections();
      print('_rankingCollections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchRankingCollections: $e');
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      _rankingSelections = await ApiService.getRankingSelections();
      print('_rankingSelections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchRankingSelections: $e');
    }
  }

  Future<void> fetchRankingUsers() async {
    try {
      _rankingUsers = await ApiService.getRankingUsers();
      print('_rankingUsers');
      notifyListeners();
    } catch (e) {
      print('Failed to rankingUsers: $e');
    }
  }
}
