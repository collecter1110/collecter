import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';
import '../services/api_service.dart';

class SearchProvider with ChangeNotifier {
  String _selectedCategoryName = 'Collection';
  final List<String> _categoryNames = ['Collection', 'Selection', 'User'];
  int _selectedCategoryIndex = 0;
  String? _searchText;
  String? _keywordCurrentSearchText;
  String? _tagCurrentSearchText;
  String? _selectionCurrentSearchText;
  String? _userCurrentSearchText;

  List<CollectionModel>? _searchKeywordCollections;
  List<CollectionModel>? _searchTagCollections;
  List<SelectionModel>? _searchSelections;
  List<UserInfoModel>? _searchUsers;

  List<String> _subCategoryNames = ['Keyword', 'Tag'];
  int _selectedSubCategoryIndex = 0;
  bool _isKeyword = true;

  String get selectedCategoryName => _selectedCategoryName;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  int get selectedSubCategoryIndex => _selectedSubCategoryIndex;
  bool get isKeyword => _isKeyword;
  List<String> get subCategoryNames => _subCategoryNames;
  String? get searchText => _searchText;
  List<CollectionModel>? get searchKeywordCollections =>
      _searchKeywordCollections;
  List<CollectionModel>? get searchTagCollections => _searchTagCollections;
  List<SelectionModel>? get searchSelections => _searchSelections;
  List<UserInfoModel>? get searchUsers => _searchUsers;

  set saveSearchText(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  set setCategoryIndex(int? categoryIndex) {
    _selectedCategoryIndex = categoryIndex!;
    _selectedCategoryName = _categoryNames[categoryIndex];
    if (categoryIndex == 0) {
      _subCategoryNames = ['Keyword', 'Tag'];
    } else if (categoryIndex == 1) {
      _subCategoryNames = ['Keyword'];
    } else {
      _subCategoryNames.clear();
    }

    notifyListeners();
  }

  set setSubCategoryIndex(int? index) {
    _selectedSubCategoryIndex = index!;
    _isKeyword = _selectedSubCategoryIndex == 0;
    notifyListeners();
  }

  Future<void> getKeywordCollectionData(String searchText) async {
    try {
      if (_keywordCurrentSearchText != searchText) {
        await fetchKeywordCollections(searchText);
      }
      _keywordCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getTagCollectionData(String searchText) async {
    try {
      if (_tagCurrentSearchText != searchText) {
        await fetchTagCollections(searchText);
      }
      _tagCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getSearchSelectionData(String searchText) async {
    try {
      if (_selectionCurrentSearchText != searchText) {
        await fetchSearchSelections(searchText);
      }
      _selectionCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> getSearchUsers(String searchText) async {
    try {
      if (_userCurrentSearchText != searchText) {
        await fetchSearchUsers(searchText);
      }
      _userCurrentSearchText = searchText;
    } catch (e) {
    } finally {}
  }

  Future<void> fetchKeywordCollections(String searchText) async {
    try {
      _searchKeywordCollections =
          await ApiService.searchCollectionsByKeyword(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTagCollections(String searchText) async {
    try {
      _searchTagCollections =
          await ApiService.searchCollectionsByTag(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchSearchSelections(String searchText) async {
    try {
      _searchSelections = await ApiService.searchSelections(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchSearchUsers(String searchText) async {
    try {
      _searchUsers = await ApiService.searchUsers(searchText);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }
}
