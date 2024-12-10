class CategoryModel {
  int categoryId;
  String categoryName;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['category_id'],
        categoryName = json['category_name'];
}
