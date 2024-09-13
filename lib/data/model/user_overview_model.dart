class UserOverviewModel {
  final List<int> labels;
  final int collectionNum;
  final int selectingNum;
  final int selectedNum;

  UserOverviewModel({
    required this.labels,
    required this.collectionNum,
    required this.selectingNum,
    required this.selectedNum,
  });

  UserOverviewModel.fromJson(Map<String, dynamic> json)
      : labels = (json['label_ids'] as List<dynamic>)
            .map((item) => item as int)
            .toList(),
        collectionNum = json['collection_num'],
        selectingNum = json['selecting_num'],
        selectedNum = json['selected_num'];
}
