import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState? _state;
  List<CollectionModel>? _searchCollections;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  int? _collectionIndex;
  int? _currentPageNum;

  ConnectionState? get state => _state;
  List<CollectionModel>? get searchCollections => _searchCollections;
  List<CollectionModel>? get myCollections => _myCollections;
  List<CollectionModel>? get likeCollections => _likeCollections;
  CollectionModel? get collectionDetail => _collectionDetail;
  int? get collectionId => _collectionId;
  int? get collectionIndex => _collectionIndex;

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
    getCollectionData();
  }

  set getCollectionId(int? collectionId) {
    _collectionId = collectionId;
  }

  set saveCollectionIndex(int? index) {
    _collectionIndex = index;
    notifyListeners();
  }

  Future<void> getCollectionData() async {
    _state = ConnectionState.waiting;

    await Future.delayed(Duration(milliseconds: 500));
    try {
      if (_currentPageNum == 0 && _myCollections == null) {
        await fetchCollections();
      } else if (_currentPageNum == 1 && _likeCollections == null) {
        await fetchLikeCollections();
      }
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSearchCollectionData(
      String searchText, bool isKeyword) async {
    _state = ConnectionState.waiting;

    await Future.delayed(Duration(milliseconds: 300));
    try {
      if (searchText == '') {
        return;
      }
      await fetchSearchCollections(searchText, isKeyword);
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  List<CollectionModel>? getCollections() {
    return _currentPageNum == 0 ? _myCollections : _likeCollections;
  }

  List<CollectionModel>? getSearchCollections() {
    return _searchCollections;
  }

  Future<void> fetchCollections() async {
    try {
      _myCollections = await ApiService.getCollections();
      print('getCollections');
    } catch (e) {
      print('Failed to fetch collections: $e');
    } finally {}
  }

  Future<void> fetchLikeCollections() async {
    try {
      _likeCollections = await ApiService.getLikeCollections();
    } catch (e) {
      print('Failed to fetch like collections: $e');
    } finally {}
  }

  Future<void> fetchSearchCollections(String searchText, bool isKeyword) async {
    try {
      _searchCollections =
          await ApiService.searchCollections(searchText, isKeyword);
      print('get search collection ');
    } catch (e) {
      print('Failed to fetch search collection: $e');
    } finally {}
  }

  Future<void> getCollectionDetailData() async {
    await fetchCollectionDetail();
    print('getCollectionData');
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
