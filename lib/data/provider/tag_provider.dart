import 'package:flutter/material.dart';

class TagProvider extends ChangeNotifier {
  final List<String> _tagNames = [];
  bool _tagState = false;

  List<String> get tagNames => _tagNames;
  bool get tagState => _tagState;

  set addTag(String tagName) {
    if (tagName == '') {
      return;
    }
    _tagNames.add(tagName);
    _tagState = true;
    notifyListeners();
  }

  Future<void> deleteTag(int index) async {
    _tagNames.removeAt(index);
    notifyListeners();
  }

  void clearTag() {
    _tagNames.clear();
    notifyListeners();
  }
}
