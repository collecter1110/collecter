import 'item_model.dart';
import 'keyword_model.dart';

class SelectionModel {
  final int categoryId;
  final int collectionId;
  final int selectionId;
  final int ownerId;
  final int? userId;
  final String title;
  final String? description;
  final List<dynamic>? imageFilePaths;
  final List<KeywordModel>? keywords;
  final String? link;
  final List<ItemData>? items;
  final bool? isOrdered;
  final bool? isSelectable;
  final String? createdAt;
  final String ownerName;
  final bool? isSelecting;
  final String? thumbFilePath;

  SelectionModel({
    required this.categoryId,
    required this.collectionId,
    required this.selectionId,
    required this.ownerId,
    this.userId,
    required this.title,
    this.description,
    this.imageFilePaths,
    this.keywords,
    this.link,
    this.items,
    this.isOrdered,
    this.isSelectable,
    this.createdAt,
    required this.ownerName,
    this.isSelecting,
    this.thumbFilePath,
  });

  factory SelectionModel.fromJson(Map<String, dynamic> json,
      {String? thumbFilePath}) {
    return SelectionModel(
      categoryId: json['category_id'],
      collectionId: json['collection_id'],
      selectionId: json['selection_id'],
      ownerId: json['owner_id'],
      userId: json['user_id'] as int?,
      title: json['title'],
      description: json['description'] as String?,
      imageFilePaths: json['image_file_paths'] as List<dynamic>?,
      keywords: json['keywords'] != null
          ? (json['keywords'] as List<dynamic>)
              .map((item) => KeywordModel.fromJson(item))
              .toList()
          : null,
      link: json['link'] as String?,
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) => ItemData.fromJson(item))
              .toList()
          : null,
      isSelectable: json['is_selectable'] as bool?,
      isOrdered: json['is_ordered'] as bool?,
      createdAt: json['created_at'] as String?,
      ownerName: json['owner_name'],
      isSelecting: json['is_selecting'] as bool?,
      thumbFilePath: thumbFilePath as String?,
    );
  }
}
