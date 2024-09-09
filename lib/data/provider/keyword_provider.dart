import 'package:flutter/material.dart';

class KeywordProvider extends ChangeNotifier {
  final List<String> _keywordNames = [];
  bool _keywordState = false;

  List<String> get keywordNames => _keywordNames;
  bool get keywordState => _keywordState;

  set addKeyword(String keywordName) {
    if (keywordName == '') {
      return;
    }
    _keywordNames.add(keywordName);
    print(_keywordNames);
    _keywordState = true;
    notifyListeners();
  }

  Future<void> deleteKeyword(int index) async {
    _keywordNames.removeAt(index);
    notifyListeners();
  }

  void clearKeyword() {
    _keywordNames.clear();
  }
}
