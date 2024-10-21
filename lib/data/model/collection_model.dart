import 'package:collect_er/data/model/keyword_model.dart';

class CollectionModel {
  final int id;
  final String title;
  final String? description;
  final String? createdAt;
  final String? imageFilePath;
  final List<dynamic>? tags;
  final int userId;
  final String userName;
  final List<KeywordData>? primaryKeywords;
  final int? selectionNum;
  final int? likeNum;
  final bool isPublic;
  final bool? isLiked;

  CollectionModel({
    required this.id,
    required this.title,
    this.description,
    this.createdAt,
    this.imageFilePath,
    this.tags,
    required this.userId,
    required this.userName,
    this.primaryKeywords,
    this.selectionNum,
    this.likeNum,
    required this.isPublic,
    this.isLiked,
  });

  // fromJson 메서드를 수정하여 hasLiked 값을 직접 받을 수 있게 수정
  factory CollectionModel.fromJson(Map<String, dynamic> json,
      {bool? hasLiked}) {
    return CollectionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'] as String?,
      imageFilePath: json['image_file_path'] as String?,
      tags: json['tags'] as List<dynamic>?,
      userName: json['user_name'],
      userId: json['user_id'],
      primaryKeywords: (json['primary_keywords'] as List<dynamic>?)
          ?.map((keyword) => KeywordData.fromJson(keyword))
          .toList(),
      selectionNum: json['selection_num'] as int?,
      likeNum: json['like_num'] as int?,
      isPublic: json['is_public'],
      isLiked: hasLiked as bool?,
    );
  }
}
