import 'package:collecter/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categoryInfo = [];

  List<CategoryModel> get categoryInfo => _categoryInfo;

  Future<List<CategoryModel>> fetchCategoryInfo() async {
    try {
      if (_categoryInfo.isEmpty) {
        _categoryInfo = await ApiService.getCategoryInfo();
        sortCategoryInfo();
        return _categoryInfo;
      } else {
        return _categoryInfo;
      }
    } finally {}
  }

  void sortCategoryInfo() {
    _categoryInfo.sort((a, b) {
      if (a.categoryId == 0 && b.categoryId != 0) {
        return 1;
      } else if (a.categoryId != 0 && b.categoryId == 0) {
        return -1;
      } else {
        return a.categoryId.compareTo(b.categoryId);
      }
    });
  }
}
