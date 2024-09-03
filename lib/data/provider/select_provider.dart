import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/selecting_model.dart';

class SelectProvider with ChangeNotifier {
  Map<String, List<SelectingData>> _dateTimesMap = {};
  List<SelectingModel> _selectingModels = [];

  Map<String, List<SelectingData>> get dateTimesMap => _dateTimesMap;

  Future<void> getSelectData() async {
    try {
      await fetchSelectingData();
    } catch (e) {
      print('Failed to fetch select data: $e');
    }
  }

  Future<void> fetchSelectingData() async {
    _selectingModels = await ApiService.getSelectingModel();

    if (_selectingModels != null) {
      for (var model in _selectingModels) {
        _dateTimesMap[model.createdDate!] = model.data!;
      }
    }

    notifyListeners();
  }
}
