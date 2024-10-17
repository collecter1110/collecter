import 'package:flutter/material.dart';

class RankingProvider with ChangeNotifier {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  set setCategoryIndex(int? categoryIndex) {
    _selectedCategoryIndex = categoryIndex!;

    notifyListeners();
  }
}
