import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _rankingCollections;
  List<CollectionModel>? _searchKeywordCollections;
  List<CollectionModel>? _searchTagCollections;
  List<CollectionModel>? _searchUsersCollections;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  String? _collectionTitle;
  int? _currentPageNum;
  String? _keywordCurrentSearchText;
  String? _tagCurrentSearchText;

  ConnectionState get state => _state;
  List<CollectionModel>? get searchKeywordCollections =>
      _searchKeywordCollections;
  List<CollectionModel>? get rankingCollections => _rankingCollections;
  List<CollectionModel>? get searchTagCollections => _searchTagCollections;
  List<CollectionModel>? get searchUsersCollections => _searchUsersCollections;
  List<CollectionModel>? get myCollections => _myCollections;
  List<CollectionModel>? get likeCollections => _likeCollections;
  CollectionModel? get collectionDetail => _collectionDetail;
  int? get collectionId => _collectionId;
  String? get collectionTitle => _collectionTitle;

  set updateRankingCollections(List<CollectionModel> updateRankingCollection) {
    _rankingCollections = updateRankingCollection;
    print('updateRankingCollections');
    notifyListeners();
  }

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
  }

  set saveCollectionId(int? collectionId) {
    _collectionId = collectionId;
  }

  void saveCollectionTitle() {
    _collectionTitle = _myCollections
                ?.where((collection) => collection.id == _collectionId)
                .firstOrNull
                ?.title ==
            ''
        ? null
        : _myCollections
            ?.where((collection) => collection.id == _collectionId)
            .firstOrNull
            ?.title;
    notifyListeners();
  }

  void resetCollectionTitle() {
    _collectionId = null;
    _collectionTitle = null;
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

  Future<void> getCollectionData() async {
    try {
      if (_currentPageNum == 0 && _myCollections == null) {
        _state = ConnectionState.waiting;
        await Future.delayed(Duration(milliseconds: 300));
        await fetchCollections();
        await fetchLikeCollections();
      }
    } catch (e) {
      _state = ConnectionState.none;
    }
  }

  Future<void> getKeywordCollectionData(String searchText) async {
    try {
      if (_keywordCurrentSearchText != searchText) {
        await fetchKeywordCollections(searchText);
      }
      _keywordCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getTagCollectionData(String searchText) async {
    try {
      if (_tagCurrentSearchText != searchText) {
        await fetchTagCollections(searchText);
      }
      _tagCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getSearchUsersCollectionData(int userId) async {
    try {
      await fetchUsersCollections(userId);
    } catch (e) {
    } finally {}
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

  Future<void> fetchCollections() async {
    try {
      _myCollections = await ApiService.getCollections();
      print('getCollections');
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch collections: $e');
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> fetchLikeCollections() async {
    try {
      _likeCollections = await ApiService.getLikeCollections();
    } catch (e) {
      print('Failed to fetch like collections: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchUsersCollections(int userId) async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));
      _searchUsersCollections = await ApiService.getUsersCollections(userId);
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchKeywordCollections(String searchText) async {
    try {
      _searchKeywordCollections =
          await ApiService.searchCollectionsByKeyword(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTagCollections(String searchText) async {
    try {
      _searchTagCollections =
          await ApiService.searchCollectionsByTag(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCollectionDetailData() async {
    await fetchCollectionDetail();
  }

  Future<void> fetchCollectionDetail() async {
    try {
      _collectionDetail = await ApiService.getCollectionDetail(_collectionId!);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch collection detail data: $e');
    }
  }
}
