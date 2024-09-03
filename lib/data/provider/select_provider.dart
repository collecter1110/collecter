import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/selecting_model.dart';

class SelectProvider with ChangeNotifier {
  Map<String, List<SelectingData>?> _selectingMap = {};
  Map<String, List<SelectingData>?> _selectedMap = {};
  List<SelectingModel> _selectingModels = [];
  List<SelectingModel> _selectedModels = [];
  List<String> _createdDateKeys = [];
  int? _currentPageNum;

  List<String> get createdDateKeys => _createdDateKeys;
  int? get currentPage => _currentPageNum;

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
    getSelectData();
  }

  Future<void> getSelectData() async {
    if (_currentPageNum == 0 && _selectingMap.isEmpty) {
      await fetchSelectingData();
    } else if (_currentPageNum == 1 && _selectedMap.isEmpty) {
      await fetchSelectedData();
    }
    await getCreatedDates();
  }

  Future<void> getCreatedDates() async {
    try {
      _createdDateKeys = _currentPageNum == 0
          ? _selectingMap.keys
              .where((key) => _selectingMap[key] != null)
              .toList()
          : _selectedMap.keys
              .where((key) => _selectedMap[key] != null)
              .toList();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch selecting data: $e');
    }
  }

  List<SelectingData> getSelectDatas(int index) {
    List<SelectingData>? _selectDatas = _currentPageNum == 0
        ? (_selectingMap[_createdDateKeys[index]])
        : (_selectedMap[_createdDateKeys[index]]);

    return _selectDatas ?? [];
  }

  Future<void> fetchSelectingData() async {
    try {
      _selectingModels =
          await ApiService.getSelectModel('selecting_properties');

      for (var model in _selectingModels) {
        String createdDate = model.createdDate ?? '';
        List<SelectingData> data = model.data ?? [];

        if (createdDate.isNotEmpty && data.isNotEmpty) {
          _selectingMap[createdDate] = data;
        } else {
          _selectingMap[createdDate] = null;
        }
      }
      print('selecting map $_selectingMap');

      notifyListeners();
    } catch (e) {
      print('Failed to fetch selecting data: $e');
    }
  }

  Future<void> fetchSelectedData() async {
    try {
      _selectedModels = await ApiService.getSelectModel('selected_properties');

      for (var model in _selectedModels) {
        String createdDate = model.createdDate ?? '';
        List<SelectingData> data = model.data ?? [];

        if (createdDate.isNotEmpty && data.isNotEmpty) {
          _selectedMap[createdDate] = data;
        } else {
          _selectedMap[createdDate] = null;
        }
      }
      print('slected map : $_selectedMap');

      notifyListeners();
    } catch (e) {
      print('Failed to fetch selected data: $e');
    }
  }
}
