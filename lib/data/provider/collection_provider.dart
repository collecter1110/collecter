import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _searchCollections;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  int? _collectionIndex;
  int? _currentPageNum;

  ConnectionState get state => _state;
  List<CollectionModel>? get searchCollections => _searchCollections;
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
        print('이거 테스트');
        _state = ConnectionState.waiting;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 300));
        await fetchCollections();
        await fetchLikeCollections();
      }
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {}
  }

  Future<void> getSearchCollectionData(
      String searchText, bool isKeyword) async {
    _state = ConnectionState.waiting;

    await Future.delayed(Duration(milliseconds: 300));
    try {
      await fetchSearchCollections(searchText, isKeyword);
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
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
