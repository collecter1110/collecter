class UserOverviewModel {
  final int userId;
  final List<int> labels;
  final int selectingNum;
  final int selectedNum;
  final List<TimeStampedData>? selectingProperties;
  final List<TimeStampedData>? selectedProperties;

  UserOverviewModel({
    required this.userId,
    required this.labels,
    required this.selectingNum,
    required this.selectedNum,
    required this.selectingProperties,
    required this.selectedProperties,
  });

  UserOverviewModel.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        labels = (json['label_ids'] as List<dynamic>)
            .map((item) => item as int)
            .toList(),
        selectingNum = json['selecting_num'],
        selectedNum = json['selected_num'],
        selectingProperties = json['selecting_properties'] != null
            ? (json['selecting_properties'] as List<dynamic>)
                .map((item) => TimeStampedData.fromJson(item))
                .toList()
            : null,
        selectedProperties = json['selected_properties'] != null
            ? (json['selected_properties'] as List<dynamic>)
                .map((item) => TimeStampedData.fromJson(item))
                .toList()
            : null;
}

class TimeStampedData {
  final String createdDate;
  final List<CreatedTimeData> times;

  TimeStampedData({
    required this.createdDate,
    required this.times,
  });

  TimeStampedData.fromJson(Map<String, dynamic> json)
      : createdDate = json['created_date'],
        times = (json['times'] as List<dynamic>)
            .map((item) => CreatedTimeData.fromJson(item))
            .toList();
}

class CreatedTimeData {
  final String createdTime;
  final List<SelectPropertiesData> properties;

  CreatedTimeData({
    required this.createdTime,
    required this.properties,
  });

  CreatedTimeData.fromJson(Map<String, dynamic> json)
      : createdTime = json['created_time'],
        properties = (json['properties'] as List<dynamic>)
            .map((item) => SelectPropertiesData.fromJson(item))
            .toList();
}

class SelectPropertiesData {
  final int selectedCollectionId;
  final int selectedSelectionId;
  final int selectedUserId;
  final int selectingCollectionId;
  final int selectingUserId;
  final int selectingSelectionId;

  SelectPropertiesData({
    required this.selectedCollectionId,
    required this.selectedSelectionId,
    required this.selectedUserId,
    required this.selectingCollectionId,
    required this.selectingUserId,
    required this.selectingSelectionId,
  });

  SelectPropertiesData.fromJson(Map<String, dynamic> json)
      : selectedCollectionId = json['selected_collection_id'],
        selectedSelectionId = json['selected_selection_id'],
        selectedUserId = json['selected_user_id'],
        selectingCollectionId = json['selecting_collection_id'],
        selectingUserId = json['selecting_user_id'],
        selectingSelectionId = json['selecting_selection_id'];
}
