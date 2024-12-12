import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class RankingProvider with ChangeNotifier {
  List<CollectionModel> _rankingCollections = [];
  final Map<int, List<CollectionModel>> _categoryCollections = {
    1: [], // Music
    2: [], // Trip
    3: [], // Book
    4: [], // Movie
    5: [], // Cook
    6: [], // Place
    7: [], // Tasting Note
    8: [] // Knitting
  };

  List<SelectionModel> _rankingSelections = [];
  final Map<int, List<SelectionModel>> _categorySelections = {
    1: [], // Music
    2: [], // Trip
    3: [], // Book
    4: [], // Movie
    5: [], // Cook
    6: [], // Place
    7: [], // Tasting Note
    8: [] // Knitting
  };

  List<UserInfoModel>? _rankingUsers;

  List<CollectionModel>? get rankingCollections => _rankingCollections;
  List<CollectionModel>? get musicCollections => _categoryCollections[1];
  List<CollectionModel>? get tripCollections => _categoryCollections[2];
  List<CollectionModel>? get bookCollections => _categoryCollections[3];
  List<CollectionModel>? get movieCollections => _categoryCollections[4];
  List<CollectionModel>? get cookCollections => _categoryCollections[5];
  List<CollectionModel>? get placeCollections => _categoryCollections[6];
  List<CollectionModel>? get tastingNoteCollections => _categoryCollections[7];
  List<CollectionModel>? get knittingCollections => _categoryCollections[8];

  List<SelectionModel>? get rankingSelections => _rankingSelections;
  List<SelectionModel>? get musicSelections => _categorySelections[1];
  List<SelectionModel>? get tripSelecitons => _categorySelections[2];
  List<SelectionModel>? get bookSelections => _categorySelections[3];
  List<SelectionModel>? get movieSelections => _categorySelections[4];
  List<SelectionModel>? get cookSelections => _categorySelections[5];
  List<SelectionModel>? get placeSelections => _categorySelections[6];
  List<SelectionModel>? get tastingNoteSelecitons => _categorySelections[7];
  List<SelectionModel>? get knittingSelections => _categorySelections[8];

  List<UserInfoModel>? get rankingUsers => _rankingUsers;
  Future<void> fetchRankingCollections() async {
    try {
      _rankingCollections = await ApiService.getRankingCollections();

      for (var list in _categoryCollections.values) {
        list.clear();
      }

      for (var collection in _rankingCollections) {
        _categoryCollections[collection.categoryId]?.add(collection);
      }

      print('Fetch ranking collections');
    } catch (e) {
      print('Failed to fetchRankingCollections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      _rankingSelections = await ApiService.getRankingSelections();

      for (var list in _categorySelections.values) {
        list.clear();
      }

      for (var selection in _rankingSelections) {
        _categorySelections[selection.categoryId]?.add(selection);
      }

      print('Fetch ranking selections');
    } catch (e) {
      print('Failed to fetchRankingSelections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRankingUsers() async {
    try {
      _rankingUsers = await ApiService.getRankingUsers();
      print('_rankingUsers');
    } catch (e) {
      print('Failed to rankingUsers: $e');
    } finally {
      notifyListeners();
    }
  }
}
