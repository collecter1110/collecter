import 'package:flutter/material.dart';

import '../model/collection_model.dart';
import '../model/selection_model.dart';
import '../model/user_info_model.dart';

class RankingProvider with ChangeNotifier {
  List<CollectionModel>? _rankingCollections;
  List<SelectionModel>? _rankingSelections;
  List<UserInfoModel>? _rankingUsers;

  List<CollectionModel>? get rankingCollections => _rankingCollections;
  List<SelectionModel>? get rankingSelections => _rankingSelections;
  List<UserInfoModel>? get rankingUsers => _rankingUsers;

  set updateRankingCollections(List<CollectionModel> updateRankingCollection) {
    _rankingCollections = updateRankingCollection;

    notifyListeners();
  }

  set updateRankingSelections(List<SelectionModel> updateRankingSelections) {
    _rankingSelections = updateRankingSelections;

    notifyListeners();
  }

  set updateRankingUsers(List<UserInfoModel> updateRankingUsers) {
    _rankingUsers = updateRankingUsers;

    notifyListeners();
  }
}
