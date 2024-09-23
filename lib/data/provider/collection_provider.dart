import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _searchKeywordCollections;
  List<CollectionModel>? _searchTagCollections;
  List<CollectionModel>? _searchUsersCollections;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  int? _collectionIndex;
  int? _currentPageNum;
  String? _currentSearchText;

  ConnectionState get state => _state;
  List<CollectionModel>? get searchKeywordCollections =>
      _searchKeywordCollections;
  List<CollectionModel>? get searchTagCollections => _searchTagCollections;
  List<CollectionModel>? get searchUsersCollections => _searchUsersCollections;
  List<CollectionModel>? get myCollections => _myCollections;
  List<CollectionModel>? get likeCollections => _likeCollections;
  CollectionModel? get collectionDetail => _collectionDetail;
  int? get collectionId => _collectionId;
  int? get collectionIndex => _collectionIndex;

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
  }

  set getCollectionId(int? collectionId) {
    _collectionId = collectionId;
  }

  set saveCollectionIndex(int? index) {
    _collectionIndex = index;
    notifyListeners();
  }

  Future<void> getCollectionData() async {
    try {
      if (_currentPageNum == 0 && _myCollections == null) {
        _state = ConnectionState.waiting;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 300));
        await fetchCollections();
        await fetchLikeCollections();
      }
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      _state = ConnectionState.done;
    }
  }

  Future<void> getSearchCollectionData(
      String searchText, bool isKeyword) async {
    try {
      if (isKeyword) {
        if (_currentSearchText != searchText ||
            _searchKeywordCollections == null) {
          await fetchSearchCollections(searchText, isKeyword);
        }
      } else {
        if (_currentSearchText != searchText || _searchTagCollections == null) {
          await fetchSearchCollections(searchText, isKeyword);
        }
      }
      _currentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getSearchUsersCollectionData(int userId) async {
    try {
      await fetchUsersCollections(userId);
    } catch (e) {
    } finally {}
  }

  Future<void> fetchCollections() async {
    try {
      _myCollections = await ApiService.getCollections();
      print('getCollections');
    } catch (e) {
      print('Failed to fetch collections: $e');
    } finally {
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
      _searchUsersCollections = await ApiService.searchUsersCollections(userId);
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchSearchCollections(String searchText, bool isKeyword) async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));
      if (isKeyword) {
        _searchKeywordCollections =
            await ApiService.searchCollections(searchText, isKeyword);
      } else {
        _searchTagCollections =
            await ApiService.searchCollections(searchText, isKeyword);
      }
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
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

  void resetCollectionIndex() {
    if (_collectionIndex != null) {
      _collectionIndex = null;
    }
  }
}
