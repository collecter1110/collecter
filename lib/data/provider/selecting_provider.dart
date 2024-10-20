import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/selecting_model.dart';

class SelectingProvider with ChangeNotifier {
  ConnectionState _state = ConnectionState.waiting;
  Map<String, List<SelectingData>?> _selectingMap = {};
  Map<String, List<SelectingData>?> _selectedMap = {};
  List<SelectingModel> _selectingModels = [];
  List<SelectingModel> _selectedModels = [];
  List<String> _selectingCreatedDates = [];
  List<String> _selectedCreatedDates = [];
  int _selectingNum = 0;
  int _selectedNum = 0;

  ConnectionState get state => _state;
  Map<String, List<SelectingData>?> get selectingMap => _selectingMap;
  Map<String, List<SelectingData>?> get selectedMap => _selectedMap;
  List<String> get selectingCreatedDates => _selectingCreatedDates;
  List<String> get selectedCreatedDates => _selectedCreatedDates;
  int get selectingNum => _selectingNum;
  int get selectedNum => _selectedNum;

  Future<void> getSelectData() async {
    try {
      if (_selectingMap.isEmpty && _selectedMap.isEmpty) {
        await fetchSelectingData();
        await fetchSelectedData();
      }
    } catch (e) {
      print('Failed to get select data: $e');
    }
  }

  Future<void> fetchSelectingData() async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));

      _selectingModels = await ApiService.getSelectings('selecting_properties');

      _selectingMap.clear();
      _selectingNum = 0;
      for (var model in _selectingModels) {
        String? createdDate = model.createdDate;
        List<SelectingData> data = model.data ?? [];
        _selectingNum += data.length;
        if (createdDate != null) {
          _selectingMap[createdDate] = data;
        } else {
          _selectingMap[''] = null;
        }
      }
      getSelectingCreatedDates();
      print('fetchSelectingData');
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch selecting data: $e');
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> fetchSelectedData() async {
    try {
      _state = ConnectionState.waiting;
      await Future.delayed(Duration(milliseconds: 300));

      _selectedModels = await ApiService.getSelectings('selected_properties');
      _selectedMap.clear();
      _selectedNum = 0;
      for (var model in _selectedModels) {
        String? createdDate = model.createdDate;
        List<SelectingData> data = model.data ?? [];
        _selectedNum += data.length;
        if (createdDate != null) {
          _selectedMap[createdDate] = data;
        } else {
          // {: null} 이런 형식으로 저장
          _selectedMap[''] = null;
        }
      }
      getSelectedCreatedDates();
      print('fetchSelectedData');
    } catch (e) {
      _state = ConnectionState.none;
      print('Failed to fetch selected data: $e');
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  void getSelectingCreatedDates() {
    try {
      _selectingCreatedDates = _selectingMap.keys
          .where((key) => _selectingMap[key] != null)
          .toList();
    } catch (e) {
      print('Failed to get selecting dates : $e');
    }
  }

  void getSelectedCreatedDates() {
    try {
      _selectedCreatedDates =
          _selectedMap.keys.where((key) => _selectedMap[key] != null).toList();
    } catch (e) {
      print('Failed to get selected dates : $e');
    }
  }
}
