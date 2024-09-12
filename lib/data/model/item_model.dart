class ItemData {
  String itemTitle;
  int itemOrder;

  ItemData({
    required this.itemTitle,
    required this.itemOrder,
  });

  ItemData.fromJson(Map<String, dynamic> json)
      : itemTitle = json['item_title'],
        itemOrder = json['item_order'];
}
