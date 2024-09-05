import 'package:collect_er/data/model/collection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  List<CollectionModel>? _collections;

  List<CollectionModel>? get collections => _collections;
  ConnectionState get state => _state;
  int? get currentPage => _currentPageNum;

  int? _currentPageNum;

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
    getCollections();
  }

  Future<void> getCollections() async {
    _state = ConnectionState.waiting;
    print('getCollections');
    try {
      await fetchCollectionData();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCollectionData() async {
    try {
      _collections = await ApiService.getCollections();
    } catch (e) {
      print('Failed to fetch collections: $e');
    }
  }
}
