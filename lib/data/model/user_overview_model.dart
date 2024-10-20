class UserOverviewModel {
  final int collectionNum;
  final int selectingNum;
  final int selectedNum;

  UserOverviewModel({
    required this.collectionNum,
    required this.selectingNum,
    required this.selectedNum,
  });

  UserOverviewModel.fromJson(Map<String, dynamic> json)
      : collectionNum = json['collection_num'],
        selectingNum = json['selecting_num'],
        selectedNum = json['selected_num'];
}
