import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listItemsProvider = ChangeNotifierProvider((ref) => ListItemsProvider());

class ListItemsProvider extends ChangeNotifier {
  List<ListItemModel> _items = [];

  List<ListItemModel> get items => _items;

  addItem(ListItemModel item, {bool asFirst = true}) {
    if (asFirst)
      _items.insert(0, item);
    else
      _items.add(item);

    notifyListeners();
  }

  addItems(List<ListItemModel> items) {
    _items.addAll(items);
    notifyListeners();
  }

  updateItem(ListItemModel item) {
    var itemIndex = _items.indexWhere((element) => element.id == item.id);
    _items[itemIndex] = item;
    notifyListeners();
  }

  deleteItem(ListItemModel item) {
    _items.remove(item);
    notifyListeners();
  }
}
