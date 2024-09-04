import 'item_model.dart';
import 'keyword_model.dart';

class SelectionDetailModel {
  final int ownerId;
  final String selectionName;
  final String? selectionDescription;
  final bool isOrdered;
  final String? selectionLink;
  final String? imageFilePath;
  final List<ItemData>? items;
  final List<KeywordData>? keywords;
  final String createdAt;
  final String ownerName;

  SelectionDetailModel({
    required this.ownerId,
    required this.selectionName,
    this.selectionDescription,
    required this.isOrdered,
    this.selectionLink,
    this.imageFilePath,
    this.items,
    this.keywords,
    required this.createdAt,
    required this.ownerName,
  });

  SelectionDetailModel.fromJson(Map<String, dynamic> json)
      : ownerId = json['owner_id'],
        selectionName = json['selection_name'],
        selectionDescription = json['selection_description'] as String?,
        isOrdered = json['is_ordered'],
        selectionLink = json['selection_link'] as String?,
        imageFilePath = json['image_file_path'] as String?,
        items = json['items'] != null
            ? (json['items'] as List<dynamic>)
                .map((item) => ItemData.fromJson(item))
                .toList()
            : null,
        keywords = json['keywords'] != null
            ? (json['keywords'] as List<dynamic>)
                .map((item) => KeywordData.fromJson(item))
                .toList()
            : null,
        createdAt = json['created_at'].toString(),
        ownerName = json['owner_name'];
}
