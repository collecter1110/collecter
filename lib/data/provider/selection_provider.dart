import 'package:flutter/material.dart';

import '../model/selecting_model.dart';
import '../model/selection_model.dart';
import '../services/api_service.dart';

class SelectionProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  int? _collectionId;
  List<SelectionModel>? _selections;
  SelectionModel? _selectionDetail;
  PropertiesData? _propertiesData;
  String? _collectionCoverImage;

  ConnectionState get state => _state;
  int? get collectionId => _collectionId;
  List<SelectionModel>? get selections => _selections;
  SelectionModel? get selectionDetail => _selectionDetail;
  String? get collectionCoverImage => _collectionCoverImage;

  set getCollectionId(int collectionId) {
    _collectionId = collectionId;
  }

  set getSelectionProperties(PropertiesData properties) {
    _propertiesData = properties;
  }

  set saveCollectionCoverImage(String coverImage) {
    _collectionCoverImage = coverImage;
  }

  Future<void> getSelectionData() async {
    _state = ConnectionState.waiting;
    await Future.delayed(Duration(milliseconds: 300));

    try {
      await fetchSelectionData();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchSelectionData() async {
    try {
      _selections = await ApiService.getSelections(_collectionId!);
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
