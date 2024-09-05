class ItemData {
  final String itemTitle;
  final String? itemLink;

  ItemData({
    required this.itemTitle,
    this.itemLink,
  });

  ItemData.fromJson(Map<String, dynamic> json)
      : itemTitle = json['item_title'],
        itemLink = json['item_link'];
}
