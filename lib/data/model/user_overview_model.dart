class UserOverviewModel {
  final int userId;
  final List<int> labels;
  final List<CreatedData>? selectingProperties;
  final List<CreatedData>? selectedProperties;

  UserOverviewModel({
    required this.userId,
    required this.labels,
    required this.selectingProperties,
    required this.selectedProperties,
  });

  UserOverviewModel.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        labels = (json['label_ids'] as List<dynamic>)
            .map((item) => item as int)
            .toList(),
        selectingProperties = json['selecting_properties'],
        selectedProperties = json['selected_properties'];
}

class CreatedData {
  final String createdDate;
  final List<CreatedTimeData> times;

  CreatedData({
    required this.createdDate,
    required this.times,
  });

  CreatedData.fromJson(Map<String, dynamic> json)
      : createdDate = json['created_date'],
        times = json['times'];
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
        properties = json['properties'];
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
