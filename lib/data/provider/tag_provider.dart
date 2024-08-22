import 'package:flutter/material.dart';

class TagProvider extends ChangeNotifier {
  final List<String> _tagNames = [];
  bool _tagState = false;

  set addTag(String tagName) {
    _tagNames.add(tagName);
    print(_tagNames);
    _tagState = true;
    notifyListeners();
  }

  Future<void> deleteTag(int index) async {
    _tagNames.removeAt(index);
    notifyListeners();
  }

  void clearTag() {
    _tagNames.clear();
  }

  List<String> get tagNames => _tagNames;
  bool get tagState => _tagState;
}
