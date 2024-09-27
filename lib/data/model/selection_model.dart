import 'item_model.dart';
import 'keyword_model.dart';

class SelectionModel {
  final int? collectionId;
  final int? selectionId;
  final int? ownerId;
  final String selectionName;
  final String? selectionDescription;
  final bool? isOrdered;
  final String? selectionLink;
  final List<dynamic>? imageFilePaths;
  final List<ItemData>? items;
  final List<KeywordData>? keywords;
  final String? createdAt;
  final String ownerName;
  final String? thumbFilePath;

  SelectionModel({
    this.collectionId,
    this.selectionId,
    this.ownerId,
    required this.selectionName,
    this.selectionDescription,
    this.isOrdered,
    this.selectionLink,
    this.imageFilePaths,
    this.items,
    this.keywords,
    this.createdAt,
    required this.ownerName,
    this.thumbFilePath,
  });

  factory SelectionModel.fromJson(Map<String, dynamic> json,
      {String? thumbFilePath}) {
    return SelectionModel(
      collectionId: json['collection_id'] as int?,
      selectionId: json['selection_id'] as int?,
      ownerId: json['owner_id'] as int?,
      selectionName: json['selection_name'],
      selectionDescription: json['selection_description'] as String?,
      isOrdered: json['is_ordered'] as bool?,
      selectionLink: json['selection_link'] as String?,
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
    );
  }
}
