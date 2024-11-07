import 'dart:async';
import 'package:collecter/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/collection_provider.dart';
import '../provider/search_provider.dart';
import '../provider/selecting_provider.dart';
import '../provider/user_info_provider.dart';
import 'locator.dart';

class DataService {
  static Future<void> reloadLocalData(
      int collectionId, int userId, int? selectionId) async {
    final collectionProvider = locator<CollectionProvider>();
    final searchProvider = locator<SearchProvider>();

    String? searchText = searchProvider.searchText;

    if (searchText != null) {
      bool existsKeywordCollections = searchProvider.searchKeywordCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsKeywordCollections) {
        await searchProvider.fetchKeywordCollections(searchText);
      }

      bool existsTagCollections = searchProvider.searchTagCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsTagCollections) {
        await searchProvider.fetchTagCollections(searchText);
      }

      bool existsSelections = searchProvider.searchSelections?.any(
              (selection) => selectionId != null
                  ? selection.selectionId == selectionId
                  : selection.collectionId == collectionId) ??
          false;

      if (existsSelections) {
        await searchProvider.fetchSearchSelections(searchText);
      }

      // bool existsUsers =
      //     searchProvider.searchUsers?.any((user) => user.userId == userId) ??
      //         false;

      // if (existsUsers) {
      //   await searchProvider.fetchSearchUsers(searchText);
      // }

      bool existsUsersCollections = collectionProvider.searchUsersCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsUsersCollections) {
        await collectionProvider.fetchUsersCollections(userId);
      }
    }
  }

  static Future<void> reloadSearchData() async {
    // final collectionProvider = locator<CollectionProvider>();
    final searchProvider = locator<SearchProvider>();
    String? searchText = searchProvider.searchText;

    if (searchText != null) {
      await searchProvider.fetchKeywordCollections(searchText);
      await searchProvider.fetchTagCollections(searchText);
      await searchProvider.fetchSearchSelections(searchText);
      await searchProvider.fetchSearchUsers(searchText);
      //await collectionProvider.fetchUsersCollections(userId);
    }
  }

  static Future<void> updateDataProcessHandler(
    BuildContext context,
    int collectionId,
    int userId,
    int? selectionId,
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
      await reloadLocalData(collectionId, userId, selectionId);
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
      await ApiService.restartSubscriptions();
      final collectionProvider = locator<CollectionProvider>();
      final selectingProvider = context.read<SelectingProvider>();
      final userInfoProvider = context.read<UserInfoProvider>();
      final searchProvider = context.read<SearchProvider>();
      await selectingProvider.getSelectData();
      await collectionProvider.fetchLikeCollections();
      await userInfoProvider.fetchUserInfo();
      searchProvider.saveSearchText = null;
    });
  }
}
