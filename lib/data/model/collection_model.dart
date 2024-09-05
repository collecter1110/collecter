import 'package:collect_er/data/model/keyword_model.dart';

class CollectionModel {
  final int id;
  final String title;
  final String? description;
  final String createdAt;
  final String? imageFilePath;
  final List<String>? tags;
  final String userName;
  final List<KeywordData>? primaryKeywords;
  final int selectionNum;

  CollectionModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.imageFilePath,
    this.tags,
    required this.userName,
    this.primaryKeywords,
    required this.selectionNum,
  });

  CollectionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'] as String?,
        createdAt = json['created_at'],
        imageFilePath = json['image_file_path'] as String?,
        tags = json['tags'],
        userName = json['user_name'],
        primaryKeywords = json['primary_keywords'] != null
            ? (json['primary_keywords'] as List<dynamic>)
                .map((item) => KeywordData.fromJson(item))
                .toList()
            : null,
        selectionNum = json['selection_num'];
}
