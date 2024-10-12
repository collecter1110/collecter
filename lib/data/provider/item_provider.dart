import 'package:collect_er/data/model/item_model.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier {
  List<ItemData> _items = [];
  List<ItemData>? _sortedItems;
  List<int> _itemOrder = [];

  List<int> get itemOrder => _itemOrder;
  List<ItemData>? get sortedItems => _sortedItems;

  set saveInitialItem(List<ItemData> item) {
    _items = item
        .map((item) =>
            ItemData(itemTitle: item.itemTitle, itemOrder: item.itemOrder))
        .toList();
  }

  void removeItemTitle(int itemKey) {
    final removedItem = _items.firstWhere(
      (item) => item.itemOrder == itemKey,
      orElse: () => ItemData(itemOrder: -1, itemTitle: ''),
    );
    if (removedItem.itemOrder != -1) {
      _items.remove(removedItem);
    } else {
      print('아이템을 찾을 수 없습니다.');
      return;
    }
  }

  set saveItemTitle(Map<int, String?> itemTitle) {
    itemTitle.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        int existingIndex = _items.indexWhere((item) => item.itemOrder == key);

        if (existingIndex != -1) {
          _items[existingIndex].itemTitle = value;
        } else {
          _items.add(ItemData(itemTitle: value, itemOrder: key));
        }
      }
    });
  }

  set saveItemOrder(List<int> itemIndexOrder) {
    _itemOrder = itemIndexOrder;
  }

  bool hasNullItemTitle() {
    print('${_items.length},${_itemOrder.length}');
    if (_items.length == _itemOrder.length) {
      return false;
    } else {
      return true;
    }
  }

  List<Map<String, dynamic>>? itemDataListToJson() {
    try {
      if (_items.isEmpty || _items == []) {
        return null;
      }
      _sortedItems = _itemOrder.map((index) {
        final item = _items.firstWhere((item) => item.itemOrder == index);
        return item;
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
    } catch (e) {
      print('Failed to itemDataListToJson: $e');
    }
  }

  void clearItems() {
    _items = [];
    _sortedItems = null;
    _itemOrder = [0];
  }
}
