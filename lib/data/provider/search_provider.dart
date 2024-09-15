import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _selectedCategoryName = 'Collection';
  List<String> _categoryNames = ['Collection', 'Selection', 'User'];
  int _selectedCategoryIndex = 0;

  List<String> _subCategoryNames = ['Keyword', 'Tag'];
  int _selectedSubCategoryIndex = 0;

  String get selectedCategoryName => _selectedCategoryName;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  int get selectedSubCategoryIndex => _selectedSubCategoryIndex;
  List<String> get subCategoryNames => _subCategoryNames;

  set setCategoryIndex(int? categoryIndex) {
    _selectedCategoryIndex = categoryIndex!;
    _selectedCategoryName = _categoryNames[categoryIndex];
    if (categoryIndex == 0) {
      _subCategoryNames = ['Keyword', 'Tag'];
    } else if (categoryIndex == 1) {
      _subCategoryNames = ['Keyword', 'Item'];
    } else {
      _subCategoryNames.clear();
    }
    _selectedSubCategoryIndex = 0;
    notifyListeners();
  }

  set setSubCategoryIndex(int? index) {
    _selectedSubCategoryIndex = index!;

    print(_selectedSubCategoryIndex);
    notifyListeners();
  }
}
