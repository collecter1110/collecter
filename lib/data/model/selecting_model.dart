import 'keyword_model.dart';

class SelectingModel {
  final String? createdDate;
  final List<SelectingData>? data;

  SelectingModel({
    required this.createdDate,
    required this.data,
  });

  SelectingModel.fromJson(Map<String, dynamic> json)
      : createdDate = json['created_date'] as String?,
        data = json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((item) => SelectingData.fromJson(item))
                .toList()
            : null;
}

class SelectingData {
  final String createdTime;
  final String selectionName;
  final String? imageFilePath;
  final List<KeywordModel>? keywords;
  final String ownerName;
  final int ownerId;
  final String? userName;
  final PropertiesData properties;

  SelectingData({
    required this.createdTime,
    required this.selectionName,
    this.imageFilePath,
    this.keywords,
    required this.ownerName,
    required this.ownerId,
    this.userName,
    required this.properties,
  });

  SelectingData.fromJson(Map<String, dynamic> json)
      : createdTime = json['created_time'],
        selectionName = json['selection_name'],
        imageFilePath = json['image_file_path'] as String?,
        keywords = json['keywords'] != null
            ? (json['keywords'] as List<dynamic>)
                .map((item) => KeywordModel.fromJson(item))
                .toList()
            : null,
        ownerName = json['owner_name'],
        ownerId = json['owner_id'],
        userName = json['user_name'] as String?,
        properties = PropertiesData.fromJson(json['properties']);
}

class PropertiesData {
  final int collectionId;
  final int selectionId;

  PropertiesData({
    required this.collectionId,
    required this.selectionId,
  });

  PropertiesData.fromJson(Map<String, dynamic> json)
      : collectionId = json['collection_id'],
        selectionId = json['selection_id'];

  Map<String, int> toMap() {
    return {
      "collection_id": collectionId,
      "selection_id": selectionId,
    };
  }
}
