import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/collection_provider.dart';
import '../provider/search_provider.dart';
import '../provider/selection_provider.dart';

class LocalData {
  static Future<void> updateLocalData(BuildContext context, int collectionId,
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
        await selectionProvider.fetchSearchSelections(searchText);
      }
    }
  }
}
