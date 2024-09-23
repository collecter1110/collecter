class UserInfoModel {
  final String name;
  final String? email;
  final String? description;
  final String? imageFilePath;
  final int? userId;

  UserInfoModel({
    required this.name,
    this.email,
    this.description,
    this.imageFilePath,
    this.userId,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'] as String?,
        description = json['description'] as String?,
        imageFilePath = json['image_url'] as String?,
        userId = json['user_id'] as int?;
}
