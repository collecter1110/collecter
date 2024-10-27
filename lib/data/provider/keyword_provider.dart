import 'package:flutter/material.dart';

import '../../components/pop_up/toast.dart';
import '../model/keyword_model.dart';

class KeywordProvider extends ChangeNotifier {
  List<String>? _keywordNames;
  bool _keywordState = false;

  List<String>? get keywordNames => _keywordNames;
  bool get keywordState => _keywordState;

  set saveKeywords(List<KeywordData> keywords) {
    _keywordNames = keywords.map((keyword) => keyword.keywordName).toList();
  }

  set addKeyword(String keywordName) {
    if (keywordName == '') {
      return;
    }

    if (_keywordNames != null && _keywordNames!.length >= 3) {
      Toast.notify('키워드는 최대 3개까지 추가가 가능합니다.');
      return;
    }
    _keywordNames ??= []; // null이면 빈 리스트로 초기화
    _keywordNames?.add(keywordName);
    print(_keywordNames);
    _keywordState = true;
    notifyListeners();
  }

  void deleteKeyword(int index) {
    if (_keywordNames != null && _keywordNames!.isNotEmpty) {
      _keywordNames!.removeAt(index);

      if (_keywordNames!.isEmpty) {
        _keywordNames = null;
      }
      notifyListeners();
    }
  }

  void clearKeywords() {
    _keywordNames = null;
    notifyListeners();
  }
}
