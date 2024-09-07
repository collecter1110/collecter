import 'package:collect_er/data/model/keyword_model.dart';

class CollectionModel {
  final int id;
  final String title;
  final String? description;
  final String? createdAt;
  final String? imageFilePath;
  final List<dynamic>? tags;
  final String userName;
  final List<KeywordData>? primaryKeywords;
  final int selectionNum;
  final int? likeNum;
  final bool isLiked; // 좋아요 여부 필드

  CollectionModel({
    required this.id,
    required this.title,
    this.description,
    this.createdAt,
    this.imageFilePath,
    this.tags,
    required this.userName,
    this.primaryKeywords,
    required this.selectionNum,
    this.likeNum,
    required this.isLiked, // 필수 매개변수로 설정
  });

  // fromJson 메서드를 수정하여 hasLiked 값을 직접 받을 수 있게 수정
  factory CollectionModel.fromJson(Map<String, dynamic> json,
      {required bool hasLiked}) {
    return CollectionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'] as String?,
      imageFilePath: json['image_file_path'] as String?,
      tags: json['tags'] as List<dynamic>?,
      userName: json['user_name'],
      primaryKeywords: (json['primary_keywords'] as List<dynamic>?)
          ?.map((keyword) => KeywordData.fromJson(keyword))
          .toList(),
      selectionNum: json['selection_num'],
      likeNum: json['like_num'] as int?,
      isLiked: hasLiked, // hasLiked 값을 isLiked에 직접 할당
    );
  }
}
