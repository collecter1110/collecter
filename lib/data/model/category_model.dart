class CategoryModel {
  int categoryId;
  String categoryName;
  String? categoryDescription;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    this.categoryDescription,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['category_id'],
        categoryName = json['category_name'],
        categoryDescription = json['category_description'] as String?;
}
