import 'package:collect_er/data/model/selecting_model.dart';
import 'package:collect_er/data/model/selection_detail_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class SelectionDetailProvider with ChangeNotifier {
  SelectionDetailModel? _selectionDetailModel;

  PropertiesData? _propertiesData;
  SelectionDetailModel? get selectionDetailModel => _selectionDetailModel;

  Future<void> getSelectionDetailData() async {
    await fetchSelectionDetail();
  }

  set getSelectionProperties(PropertiesData properties) {
    _propertiesData = properties;
  }

  Future<void> fetchSelectionDetail() async {
    try {
      _selectionDetailModel = await ApiService.getSelectionDetails(
          _propertiesData!.collectionId,
          _propertiesData!.selectionId,
          _propertiesData!.userId);

      print('selecting map $_selectionDetailModel');

      notifyListeners();
    } catch (e) {
      print('Failed to fetch selection detail data: $e');
    }
  }
}
