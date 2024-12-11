class KeywordModel {
  int keywordId;
  String keywordName;
  int? categoryId;

  KeywordModel(
      {required this.keywordId, required this.keywordName, this.categoryId});

  KeywordModel.fromJson(Map<String, dynamic> json)
      : keywordId = json['keyword_id'],
        keywordName = json['keyword_name'],
        categoryId = json['category_id'] as int?;
}
