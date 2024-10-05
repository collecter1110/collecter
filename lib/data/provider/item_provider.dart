import 'package:collect_er/data/model/item_model.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier {
  List<ItemData> _items = [];
  List<ItemData>? _sortedItems;
  List<int> _itemOrder = [];

  List<int> get itemOrder => _itemOrder;
  List<ItemData>? get sortedItems => _sortedItems;

  set saveItem(List<ItemData> item) {
    _items = item
        .map((item) =>
            ItemData(itemTitle: item.itemTitle, itemOrder: item.itemOrder))
        .toList();
  }

  set saveItemTitle(Map<int, String> itemTitle) {
    itemTitle.forEach((key, value) {
      int existingIndex = _items.indexWhere((item) => item.itemOrder == key);

      if (existingIndex != -1) {
        _items[existingIndex].itemTitle = value;
      } else {
        _items.add(ItemData(itemTitle: value, itemOrder: key));
      }
    });
  }

  set saveItemOrder(List<int> itemIndexOrder) {
    _itemOrder = itemIndexOrder;
  }

  List<Map<String, dynamic>>? itemDataListToJson() {
    if (_items.isEmpty || _items == []) {
      return null;
    }
    _sortedItems = _itemOrder.map((index) {
      return _items.firstWhere((item) => item.itemOrder == index);
    }).toList();

    for (int i = 0; i < _sortedItems!.length; i++) {
      _sortedItems![i].itemOrder = i;
    }
    return _sortedItems!.map((item) {
      return {
        'item_order': item.itemOrder,
        'item_title': item.itemTitle,
      };
    }).toList();
  }

  void clearItems() {
    _items = [];
    _sortedItems = null;
    _itemOrder = [0];
  }
}
