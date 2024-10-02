import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/selecting_model.dart';
import '../model/selection_model.dart';

class SelectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  int? _collectionId;
  List<SelectionModel>? _selections;
  List<SelectionModel>? _searchSelections;
  SelectionModel? _selectionDetail;
  PropertiesData? _propertiesData;
  String? _currentSearchText;

  ConnectionState get state => _state;
  int? get collectionId => _collectionId;
  List<SelectionModel>? get selections => _selections;
  List<SelectionModel>? get searchSelections => _searchSelections;
  SelectionModel? get selectionDetail => _selectionDetail;

  set getCollectionId(int collectionId) {
    _collectionId = collectionId;
    getSelectionData();
  }

  set getSelectionProperties(PropertiesData properties) {
    _propertiesData = properties;
  }

  Future<void> getSelectionData() async {
    _state = ConnectionState.waiting;

    try {
      await fetchSelectionData();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSearchSelectionData(String searchText) async {
    try {
      if (_currentSearchText != searchText) {
        await fetchSearchSelections(searchText);
      }
      _currentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> fetchSearchSelections(String searchText) async {
    try {
      _searchSelections = await ApiService.searchSelections(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchSelectionData() async {
    try {
      _selections = await ApiService.getSelections(_collectionId!);
      print(_selections);
    } catch (e) {
      print('Failed to fetch selection data: $e');
    }
  }

  Future<void> getSelectionDetailData() async {
    await fetchSelectionDetail();
  }

  Future<void> fetchSelectionDetail() async {
    try {
      _selectionDetail = await ApiService.getSelectionDetail(
        _propertiesData!.collectionId,
        _propertiesData!.selectionId,
      );
      notifyListeners();
    } catch (e) {
      print('Failed to fetch selection detail data: $e');
    }
  }
}
