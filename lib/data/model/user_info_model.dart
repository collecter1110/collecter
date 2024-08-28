class UserInfoModel {
  final String name;
  final String email;
  final String description;
  final String imageUrl;
  final int userId;

  UserInfoModel({
    required this.name,
    required this.email,
    required this.description,
    required this.imageUrl,
    required this.userId,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        email = json['picture'].toString(),
        description = json['bio'].toString(),
        imageUrl = json['bio'].toString(),
        userId = json['user_id'];
}
