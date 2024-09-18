import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _selectedCategoryName = 'Collection';
  List<String> _categoryNames = ['Collection', 'Selection', 'User'];
  int _selectedCategoryIndex = 0;
  String? _searchText;

  List<String> _subCategoryNames = ['Keyword', 'Tag'];
  int _selectedSubCategoryIndex = 0;
  bool _isKeyword = true;

  String get selectedCategoryName => _selectedCategoryName;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  int get selectedSubCategoryIndex => _selectedSubCategoryIndex;
  bool get isKeyword => _isKeyword;
  List<String> get subCategoryNames => _subCategoryNames;
  String? get searchText => _searchText;

  set saveSearchText(String searchText) {
    _searchText = searchText;
  }

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
    _isKeyword = true;
    notifyListeners();
  }

  set setSubCategoryIndex(int? index) {
    _selectedSubCategoryIndex = index!;
    _isKeyword = _selectedSubCategoryIndex == 0;
    notifyListeners();
  }
}
