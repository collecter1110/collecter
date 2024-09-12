class KeywordData {
  int keywordId;
  String keywordName;

  KeywordData({
    required this.keywordId,
    required this.keywordName,
  });

  KeywordData.fromJson(Map<String, dynamic> json)
      : keywordId = json['keyword_id'],
        keywordName = json['keyword_name'];
}
