import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class RankingProvider with ChangeNotifier {
  List<CollectionModel>? _musicCollections;
  List<CollectionModel>? _bookCollections;
  List<CollectionModel>? _movieCollections;
  // List<CollectionModel>? _tripCollections;
  List<CollectionModel>? _cookCollections;
  // List<CollectionModel>? _placeCollections;
  // List<CollectionModel>? _tastingNoteCollections;
  // List<CollectionModel>? _knittingCollections;
  List<SelectionModel>? _musicSelections;
  List<SelectionModel>? _bookSelections;
  List<SelectionModel>? _movieSelections;

  List<UserInfoModel>? _rankingUsers;

  List<CollectionModel>? get musicCollections => _musicCollections;
  List<CollectionModel>? get movieCollections => _movieCollections;
  List<CollectionModel>? get bookCollections => _bookCollections;
  List<SelectionModel>? get musicSelections => _musicSelections;
  List<SelectionModel>? get bookSelections => _bookSelections;
  List<SelectionModel>? get movieSelections => _movieSelections;
  List<CollectionModel>? get cookCollections => _cookCollections;

  List<UserInfoModel>? get rankingUsers => _rankingUsers;

  Future<void> fetchRankingCollections() async {
    try {
      await fetchMusicCollections();
      await fetchBookCollections();
      await fetchMovieCollections();
      await fetchCookCollections();
    } catch (e) {
      print('Failed to fetchRankingCollections: $e');
    }
  }

  Future<void> fetchMusicCollections() async {
    try {
      _musicCollections = await ApiService.getRankingCollections(1);
      print('_musicCollections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchMusicCollections: $e');
    }
  }

  Future<void> fetchBookCollections() async {
    try {
      _bookCollections = await ApiService.getRankingCollections(3);
      print('_bookCollections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchBookCollections: $e');
    }
  }

  Future<void> fetchMovieCollections() async {
    try {
      _movieCollections = await ApiService.getRankingCollections(4);
      print('_musicCollections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchMovieCollections: $e');
    }
  }

  Future<void> fetchCookCollections() async {
    try {
      _cookCollections = await ApiService.getRankingCollections(5);
      print('_cookCollections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchCookCollections: $e');
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      await fetchMusicSelections();
      await fetchBookSelections();
      await fetchMovieSelections();
    } catch (e) {
      print('Failed to fetchRankingSelections: $e');
    }
  }

  Future<void> fetchMusicSelections() async {
    try {
      _musicSelections = await ApiService.getRankingSelections(3);
      print('_musicSelections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchMusicSelections: $e');
    }
  }

  Future<void> fetchBookSelections() async {
    try {
      _bookSelections = await ApiService.getRankingSelections(1);
      print('_bookSelections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchBookSelections: $e');
    }
  }

  Future<void> fetchMovieSelections() async {
    try {
      _movieSelections = await ApiService.getRankingSelections(4);
      print('_movieSelections');
      notifyListeners();
    } catch (e) {
      print('Failed to fetchMovieSelections: $e');
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
