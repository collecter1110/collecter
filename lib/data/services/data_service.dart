import 'dart:async';
import 'package:collecter/data/provider/ranking_provider.dart';
import 'package:collecter/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/collection_provider.dart';
import '../provider/search_provider.dart';
import '../provider/selecting_provider.dart';
import '../provider/user_info_provider.dart';
import 'locator.dart';

class DataService {
  static Future<void> reloadLocalData(int userId) async {
    final collectionProvider = locator<CollectionProvider>();
    final searchProvider = locator<SearchProvider>();
    final rankingProvider = locator<RankingProvider>();

    String? searchText = searchProvider.searchText;

    if (searchText != null) {
      bool existsKeywordCollections = searchProvider.searchKeywordCollections
              ?.any((collection) => collection.userId == userId) ??
          false;

      if (existsKeywordCollections) {
        await searchProvider.fetchKeywordCollections(searchText);
      }

      bool existsTagCollections = searchProvider.searchTagCollections
              ?.any((collection) => collection.userId == userId) ??
          false;

      if (existsTagCollections) {
        await searchProvider.fetchTagCollections(searchText);
      }

      bool existsSelections = searchProvider.searchSelections
              ?.any((selection) => selection.userId == userId) ??
          false;

      if (existsSelections) {
        await searchProvider.fetchSearchSelections(searchText);
      }

      bool existsUsersInfo = searchProvider.searchUsers
              ?.any((userInfo) => userInfo.userId == userId) ??
          false;

      if (existsUsersInfo) {
        await searchProvider.fetchSearchUsers(searchText);
      }

      bool existsUsersCollections = collectionProvider.searchUsersCollections
              ?.any((collection) => collection.userId == userId) ??
          false;

      if (existsUsersCollections) {
        await collectionProvider.fetchUsersCollections(userId);
      }
    }

    bool existLikeCollections = collectionProvider.likeCollections
            ?.any((collection) => collection.userId == userId) ??
        false;

    if (existLikeCollections) {
      await collectionProvider.fetchLikeCollections();
    }

    bool existsRankingCollections = rankingProvider.rankingCollections
            ?.any((collection) => collection.userId == userId) ??
        false;

    if (existsRankingCollections) {
      await rankingProvider.fetchRankingCollections();
    }
    bool existsRankingSelections = rankingProvider.rankingSelections
            ?.any((selection) => selection.userId == userId) ??
        false;

    if (existsRankingSelections) {
      await rankingProvider.fetchRankingSelections();
    }

    // bool existsUsers = rankingProvider.rankingUsers
    //         ?.any((userInfo) => userInfo.userId == userId) ??
    //     false;

    // if (existsUsers) {
    //   await rankingProvider.fetchRankingUsers();
    // }
  }

  static Future<void> updateDataProcessHandler(
    BuildContext context,
    Future<void> Function() updateData,
    Future<void> Function() nextNavigate,
  ) async {
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext newContext) {
        dialogContext = newContext;
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await nextNavigate();
      await updateData();
    } catch (e) {
      print('Error: $e');
    } finally {
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }
    }
  }

  static Future<void> loadInitialData(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ApiService.startSubscriptions();
      await ApiService.initializeBlockedIds();
      await ApiService.initializeMyCollections();
      final rankingProvider = locator<RankingProvider>();
      final collectionProvider = locator<CollectionProvider>();
      final selectingProvider = context.read<SelectingProvider>();
      final userInfoProvider = context.read<UserInfoProvider>();
      final searchProvider = context.read<SearchProvider>();
      await rankingProvider.fetchRankingCollections();
      await rankingProvider.fetchRankingSelections();
      await rankingProvider.fetchRankingUsers();
      await selectingProvider.getSelectData();
      await collectionProvider.fetchLikeCollections();
      await userInfoProvider.fetchUserInfo();
      searchProvider.saveSearchText = null;
    });
  }
}
