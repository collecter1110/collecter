import 'package:flutter/material.dart';

class TagProvider extends ChangeNotifier {
  List<String>? _tagNames;
  bool _tagState = false;

  List<String>? get tagNames => _tagNames;
  bool get tagState => _tagState;

  set saveTags(List<dynamic> tags) {
    _tagNames = tags.map((tag) => tag.toString()).toList();
  }

  set addTag(String tagName) {
    if (tagName == '') {
      return;
    }
    _tagNames ??= []; // null이면 빈 리스트로 초기화
    _tagNames?.add(tagName);

    print(' $_tagNames');
    _tagState = true;
    notifyListeners();
  }

  Future<void> deleteTag(int index) async {
    if (_tagNames != null && _tagNames!.isNotEmpty) {
      _tagNames!.removeAt(index);

      // 리스트가 비었으면 null로 설정
      if (_tagNames!.isEmpty) {
        _tagNames = null;
      }

      notifyListeners();
    }
  }

  Future<void> clearTags() async {
    _tagNames = null;

    notifyListeners();
  }
}
