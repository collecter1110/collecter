import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  int? _collectionIndex;

  List<CollectionModel>? get myCollections => _myCollections;
  List<CollectionModel>? get likeCollections => _likeCollections;
  CollectionModel? get collectionDetail => _collectionDetail;
  int? get collectionId => _collectionId;
  int? get collectionIndex => _collectionIndex;

  ConnectionState get state => _state;
  int? get currentPage => _currentPageNum;

  int? _currentPageNum;

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

  void resetCollectionIndex() {
    if (_collectionIndex != null) {
      _collectionIndex = null;
    }
  }

  Future<void> getCollectionData() async {
    _state = ConnectionState.waiting;
    print('getCollections');
    // await Future.delayed(Duration(seconds: 1));
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

  List<CollectionModel>? getCollections() {
    return _currentPageNum == 0 ? _myCollections : _likeCollections;
  }

  Future<void> fetchCollections() async {
    try {
      _myCollections = await ApiService.getCollections();
      print('페치');
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
}
