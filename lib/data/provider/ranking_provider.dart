import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class RankingProvider with ChangeNotifier {
  List<CollectionModel>? _musicCollections;
  List<CollectionModel>? _bookCollections;
  List<CollectionModel>? _movieCollections;
  List<CollectionModel>? _tripCollections;
  List<CollectionModel>? _cookCollections;
  List<CollectionModel>? _placeCollections;
  List<CollectionModel>? _tastingNoteCollections;
  List<CollectionModel>? _knittingCollections;
  List<SelectionModel>? _musicSelections;
  List<SelectionModel>? _bookSelections;
  List<SelectionModel>? _movieSelections;

  List<UserInfoModel>? _rankingUsers;

  List<CollectionModel>? get musicCollections => _musicCollections;
  List<CollectionModel>? get movieCollections => _movieCollections;
  List<CollectionModel>? get bookCollections => _bookCollections;
  List<CollectionModel>? get cookCollections => _cookCollections;
  List<CollectionModel>? get tripCollections => _tripCollections;
  List<CollectionModel>? get placeCollections => _placeCollections;
  List<CollectionModel>? get tastingNoteCollections => _tastingNoteCollections;
  List<CollectionModel>? get knittingCollections => _knittingCollections;

  List<SelectionModel>? get musicSelections => _musicSelections;
  List<SelectionModel>? get bookSelections => _bookSelections;
  List<SelectionModel>? get movieSelections => _movieSelections;

  List<UserInfoModel>? get rankingUsers => _rankingUsers;

  Future<void> fetchRankingCollections() async {
    try {
      await fetchMusicCollections();
      await fetchBookCollections();
      await fetchMovieCollections();
      await fetchCookCollections();
      await fetchTripCollections();
      await fetchPlaceCollections();
      await fetchTastingNoteCollections();
      await fetchKnittingCollections();
    } catch (e) {
      print('Failed to fetchRankingCollections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMusicCollections() async {
    try {
      _musicCollections = await ApiService.getRankingCollections(1);
      print('_musicCollections');
    } catch (e) {
      print('Failed to fetchMusicCollections: $e');
    }
  }

  Future<void> fetchBookCollections() async {
    try {
      _bookCollections = await ApiService.getRankingCollections(3);
      print('_bookCollections');
    } catch (e) {
      print('Failed to fetchBookCollections: $e');
    }
  }

  Future<void> fetchMovieCollections() async {
    try {
      _movieCollections = await ApiService.getRankingCollections(4);
      print('_musicCollections');
    } catch (e) {
      print('Failed to fetchMovieCollections: $e');
    }
  }

  Future<void> fetchCookCollections() async {
    try {
      _cookCollections = await ApiService.getRankingCollections(5);
      print('_cookCollections');
    } catch (e) {
      print('Failed to fetchCookCollections: $e');
    }
  }

  Future<void> fetchTripCollections() async {
    try {
      _tripCollections = await ApiService.getRankingCollections(2);
      print('_tripCollections');
    } catch (e) {
      print('Failed to fetchTripCollections: $e');
    }
  }

  Future<void> fetchPlaceCollections() async {
    try {
      _placeCollections = await ApiService.getRankingCollections(6);
      print('_placeCollections');
    } catch (e) {
      print('Failed to fetchPlaceCollections: $e');
    }
  }

  Future<void> fetchTastingNoteCollections() async {
    try {
      _tastingNoteCollections = await ApiService.getRankingCollections(7);
      print('_tastingNoteCollections');
    } catch (e) {
      print('Failed to fetchTastingNoteCollections: $e');
    }
  }

  Future<void> fetchKnittingCollections() async {
    try {
      _knittingCollections = await ApiService.getRankingCollections(8);
      print('_knittingCollections');
    } catch (e) {
      print('Failed to fetchKnittingCollections: $e');
    }
  }

  Future<void> fetchRankingSelections() async {
    try {
      await fetchMusicSelections();
      await fetchBookSelections();
      await fetchMovieSelections();
    } catch (e) {
      print('Failed to fetchRankingSelections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMusicSelections() async {
    try {
      _musicSelections = await ApiService.getRankingSelections(3);
      print('_musicSelections');
    } catch (e) {
      print('Failed to fetchMusicSelections: $e');
    }
  }

  Future<void> fetchBookSelections() async {
    try {
      _bookSelections = await ApiService.getRankingSelections(1);
      print('_bookSelections');
    } catch (e) {
      print('Failed to fetchBookSelections: $e');
    }
  }

  Future<void> fetchMovieSelections() async {
    try {
      _movieSelections = await ApiService.getRankingSelections(4);
      print('_movieSelections');
    } catch (e) {
      print('Failed to fetchMovieSelections: $e');
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
