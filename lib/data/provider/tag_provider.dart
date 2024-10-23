import 'package:flutter/material.dart';

import '../../components/pop_up/toast.dart';

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

    if (_tagNames != null && _tagNames!.length >= 10) {
      Toast.notify('태그는 최대 10개까지 가능합니다.');
      return;
    }
    _tagNames ??= [];
    _tagNames?.add(tagName);

    print(' $_tagNames');
    _tagState = true;

    notifyListeners();
  }

  void deleteTag(int index) {
    if (_tagNames != null && _tagNames!.isNotEmpty) {
      _tagNames!.removeAt(index);

      // 리스트가 비었으면 null로 설정
      if (_tagNames!.isEmpty) {
        _tagNames = null;
      }

      notifyListeners();
    }
  }

  clearTags() {
    _tagNames = null;

    notifyListeners();
  }
}
