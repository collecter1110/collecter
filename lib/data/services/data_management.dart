import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../provider/collection_provider.dart';
import '../provider/ranking_provider.dart';
import '../provider/search_provider.dart';
import '../provider/selecting_provider.dart';
import '../provider/selection_provider.dart';
import 'locator.dart';

class DataManagement {
  static Future<void> reloadLocalData(BuildContext context, int collectionId,
      int userId, int? selectionId) async {
    final collectionProvider = context.read<CollectionProvider>();
    final searchProvider = context.read<SearchProvider>();
    final selectionProvider = context.read<SelectionProvider>();
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

  static String getFullImageUrl(
      String storageFolderName, String imageFilePath) {
    // 환경 변수에서 Supabase URL 가져오기
    final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';

    // 전체 URL 생성 (버킷 이름과 폴더 경로 포함)
    return '$supabaseUrl/storage/v1/object/public/images/$storageFolderName/$imageFilePath';
  }

  static Future<void> loadInitialData(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rankingProvider = locator<RankingProvider>();
      final collectionProvider = locator<CollectionProvider>();
      final selectingProvider = context.read<SelectingProvider>();
      await rankingProvider.getInitialRankingCollectionData();
      await rankingProvider.getInitialRankingSelectionData();
      await rankingProvider.getInitialRankingUserData();
      await collectionProvider.getInitialMyCollectionData();
      await selectingProvider.getSelectData();
    });
  }
}
