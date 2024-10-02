import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/selecting_model.dart';

class SelectingProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  Map<String, List<SelectingData>?> _selectingMap = {};
  Map<String, List<SelectingData>?> _selectedMap = {};
  List<SelectingModel> _selectingModels = [];
  List<SelectingModel> _selectedModels = [];
  List<String> _createdDates = [];
  int? _currentPageNum;

  ConnectionState get state => _state;
  List<String> get createdDates => _createdDates;
  int? get currentPage => _currentPageNum;

  set setPageChanged(int currentPageNum) {
    _currentPageNum = currentPageNum;
    getSelectData();
  }

  Future<void> getSelectData() async {
    _state = ConnectionState.waiting;

    try {
      if (_currentPageNum == 0 && _selectingMap.isEmpty) {
        await fetchSelectingData();
      } else if (_currentPageNum == 1 && _selectedMap.isEmpty) {
        await fetchSelectedData();
      }
      getCreatedDates();
      _state = ConnectionState.done;
    } catch (e) {
      _state = ConnectionState.none;
    } finally {
      notifyListeners();
    }
  }

  void getCreatedDates() {
    try {
      _createdDates = _currentPageNum == 0
          ? _selectingMap.keys
              .where((key) => _selectingMap[key] != null)
              .toList()
          : _selectedMap.keys
              .where((key) => _selectedMap[key] != null)
              .toList();
    } catch (e) {
      print('Failed to fetch created dates data: $e');
    }
  }

  List<SelectingData> getSelectDatas(int index) {
    List<SelectingData>? _selectDatas = _currentPageNum == 0
        ? (_selectingMap[_createdDates[index]])
        : (_selectedMap[_createdDates[index]]);

    return _selectDatas ?? [];
  }

  Future<void> fetchSelectingData() async {
    try {
      _selectingModels = await ApiService.getSelectings('selecting_properties');

      for (var model in _selectingModels) {
        String createdDate = model.createdDate ?? '';
        List<SelectingData> data = model.data ?? [];

        if (createdDate.isNotEmpty && data.isNotEmpty) {
          _selectingMap[createdDate] = data;
        } else {
          // {: null} 이런 형식으로 저장
          _selectingMap[createdDate] = null;
        }
      }
      print('selecting map $_selectingMap');
    } catch (e) {
      print('Failed to fetch selecting data: $e');
    }
  }

  Future<void> fetchSelectedData() async {
    try {
      _selectedModels = await ApiService.getSelectings('selected_properties');

      for (var model in _selectedModels) {
        String createdDate = model.createdDate ?? '';
        List<SelectingData> data = model.data ?? [];

        if (createdDate.isNotEmpty && data.isNotEmpty) {
          _selectedMap[createdDate] = data;
        } else {
          // {: null} 이런 형식으로 저장
          _selectedMap[createdDate] = null;
        }
      }
      print('slected map : $_selectedMap');
    } catch (e) {
      print('Failed to fetch selected data: $e');
    }
  }
}
