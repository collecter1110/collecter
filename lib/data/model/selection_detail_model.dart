import 'item_model.dart';
import 'keyword_model.dart';

class SelectionDetailModel {
  final int collectionId;
  final int selectionId;
  final int ownerId;
  final String selectionName;
  final String? selectionDescription;
  final int userId;
  final bool isOrdered;
  final String? selectionLink;
  final String? imageFilePath;
  final List<ItemData>? items;
  final List<KeywordData>? keywords;
  final String createdAt;
  final String userName;

  SelectionDetailModel({
    required this.collectionId,
    required this.selectionId,
    required this.ownerId,
    required this.selectionName,
    this.selectionDescription,
    required this.userId,
    required this.isOrdered,
    this.selectionLink,
    this.imageFilePath,
    this.items,
    this.keywords,
    required this.createdAt,
    required this.userName,
  });

  SelectionDetailModel.fromJson(Map<String, dynamic> json)
      : collectionId = json['collection_id'],
        selectionId = json['selection_id'],
        ownerId = json['owner_id'],
        selectionName = json['selection_name'],
        selectionDescription = json['selection_description'],
        userId = json['user_id'],
        isOrdered = json['is_ordered'],
        selectionLink = json['selection_link'],
        imageFilePath = json['image_file_path'],
        items = (json['items'] as List<dynamic>)
            .map((item) => ItemData.fromJson(item))
            .toList(),
        keywords = (json['keywords'] as List<dynamic>)
            .map((item) => KeywordData.fromJson(item))
            .toList(),
        createdAt = json['createdAt'].toString(),
        userName = json['user_name'];
}
