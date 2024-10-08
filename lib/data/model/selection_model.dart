import 'item_model.dart';
import 'keyword_model.dart';

class SelectionModel {
  final int collectionId;
  final int selectionId;
  final int? ownerId;
  final int? userId;
  final String title;
  final String? description;
  final bool? isOrdered;
  final String? link;
  final List<dynamic>? imageFilePaths;
  final List<ItemData>? items;
  final List<KeywordData>? keywords;
  final String? createdAt;
  final String ownerName;
  final String? thumbFilePath;
  final bool? isSelect;

  SelectionModel({
    required this.collectionId,
    required this.selectionId,
    this.ownerId,
    this.userId,
    required this.title,
    this.description,
    this.isOrdered,
    this.link,
    this.imageFilePaths,
    this.items,
    this.keywords,
    this.createdAt,
    required this.ownerName,
    this.thumbFilePath,
    this.isSelect,
  });

  factory SelectionModel.fromJson(Map<String, dynamic> json,
      {String? thumbFilePath}) {
    return SelectionModel(
      collectionId: json['collection_id'],
      selectionId: json['selection_id'],
      ownerId: json['owner_id'] as int?,
      userId: json['user_id'] as int?,
      title: json['title'],
      description: json['description'] as String?,
      isOrdered: json['is_ordered'] as bool?,
      link: json['link'] as String?,
      imageFilePaths: json['image_file_paths'] as List<dynamic>?,
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) => ItemData.fromJson(item))
              .toList()
          : null,
      keywords: json['keywords'] != null
          ? (json['keywords'] as List<dynamic>)
              .map((item) => KeywordData.fromJson(item))
              .toList()
          : null,
      createdAt: json['created_at'] as String?,
      ownerName: json['owner_name'],
      thumbFilePath: thumbFilePath as String?,
      isSelect: json['is_select'] as bool?,
    );
  }
}
