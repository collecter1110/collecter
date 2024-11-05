import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/collection_model.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.done;

  List<CollectionModel>? _searchUsersCollections;
  List<CollectionModel>? _myCollections;
  List<CollectionModel>? _likeCollections;
  CollectionModel? _collectionDetail;
  int? _collectionId;
  String? _collectionTitle;
  int _collectionNum = 0;

  ConnectionState get state => _state;

  List<CollectionModel>? get searchUsersCollections => _searchUsersCollections;
  List<CollectionModel>? get myCollections => _myCollections;
  List<CollectionModel>? get likeCollections => _likeCollections;
  CollectionModel? get collectionDetail => _collectionDetail;
  int? get collectionId => _collectionId;
  String? get collectionTitle => _collectionTitle;
  int get collectionNum => _collectionNum;

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

  set updateCollections(List<CollectionModel> updateCollections) {
    _myCollections = updateCollections;
    _collectionNum = _myCollections?.length ?? 0;
    notifyListeners();
  }

  Future<void> getSearchUsersCollectionData(int userId) async {
    try {
      await fetchUsersCollections(userId);
    } catch (e) {
    } finally {}
  }

  Future<void> fetchLikeCollections() async {
    try {
      _likeCollections = await ApiService.getLikeCollections();
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch like collections: $e');
    } finally {
      _state = ConnectionState.done;
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
