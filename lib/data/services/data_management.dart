import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/collection_provider.dart';
import '../provider/search_provider.dart';
import '../provider/selection_provider.dart';

class DataManagement {
  static Future<void> reloadLocalData(BuildContext context, int collectionId,
      int userId, int? selectionId) async {
    final collectionProvider = context.read<CollectionProvider>();
    final searchProvider = context.read<SearchProvider>();
    final selectionProvider = context.read<SelectionProvider>();
    String? searchText = searchProvider.searchText;
    await collectionProvider.fetchCollections();

    if (searchText != null) {
      bool existsKeywordCollections = collectionProvider
              .searchKeywordCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsKeywordCollections) {
        await collectionProvider.fetchKeywordCollections(searchText);
      }

      bool existsTagCollections = collectionProvider.searchTagCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsTagCollections) {
        await collectionProvider.fetchTagCollections(searchText);
      }

      bool existsUsersCollections = collectionProvider.searchUsersCollections
              ?.any((collection) => collection.id == collectionId) ??
          false;

      if (existsUsersCollections) {
        await collectionProvider.fetchUsersCollections(userId);
      }

      bool existsSelections = selectionProvider.searchSelections?.any(
              (selection) => selectionId != null
                  ? selection.selectionId == selectionId
                  : selection.collectionId == collectionId) ??
          false;

      if (existsSelections) {
        print('dd');
        await selectionProvider.fetchSearchSelections(searchText);
      }
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
      await updateData();
      await reloadLocalData(context, collectionId, userId, selectionId);
    } catch (e) {
      print('Error: $e');
    } finally {
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }
      await nextNavigate();
    }
  }
}
