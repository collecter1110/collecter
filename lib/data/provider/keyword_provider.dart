import 'package:flutter/material.dart';

class KeywordProvider extends ChangeNotifier {
  final List<String> _keywordNames = [];
  bool _keywordState = false;

  set addTag(String tagName) {
    _keywordNames.add(tagName);
    print(_keywordNames);
    _keywordState = true;
    notifyListeners();
  }

  Future<void> deleteTag(int index) async {
    _keywordNames.removeAt(index);
    notifyListeners();
  }

  void clearTag() {
    _keywordNames.clear();
  }

  List<String> get keywordNames => _keywordNames;
  bool get keywordState => _keywordState;
}
