import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listProvider = ChangeNotifierProvider((ref) => ListProvider());

class ListProvider extends ChangeNotifier {
  ListModel? _list;

  ListModel? get list => _list;

  void setList(ListModel? list) {
    _list = list;
    notifyListeners();
  }

  void clearItems() {
    if (_list == null || _list?.items == null) return;
    _list!.items!.clear();
    _list!.cntItems = 0;
    _list!.cntBoughtItems = 0;
    notifyListeners();
  }

  void addItems(List<ListItemModel> items, {bool shouldClear = false}) {
    if (_list == null) return;

    if (_list!.items == null) {
      _list!.items = [];
    }

    if (shouldClear) {
      this.clearItems();
    }

    _list!.items!.addAll(items);
    _list!.cntItems += items.length;
    _list!.cntBoughtItems +=
        items.where((element) => element.purchasedAt != null).length;
    notifyListeners();
  }

  void updateItem(ListItemModel item) {
    if (list?.items == null) return;

    var itemIndex = list?.items?.indexWhere((e) => e.id == item.id);
    if (itemIndex == null || itemIndex == -1) return;

    list?.items?[itemIndex] = item;
    notifyListeners();
  }

  void deleteItem(ListItemModel item) {
    if (_list == null || _list?.items == null) return;
    _list?.items?.remove(item);
    _list!.cntItems -= 1;
    if (item.purchasedAt != null) _list!.cntBoughtItems -= 1;
    notifyListeners();
  }

  void addUsers(List<UserModel> users) {
    if (_list == null) return;

    if (_list?.users == null) {
      _list!.users = [];
    }

    _list?.users?.addAll(users);
    _list!.cntUsers += users.length;
    notifyListeners();
  }

  void deleteUser(UserModel user) {
    if (_list == null || _list?.users == null) return;
    _list?.users?.remove(user);
    _list!.cntUsers -= 1;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    if (list?.users == null) return;

    var userIndex = list?.users?.indexOf(user);
    if (userIndex == null) return;

    list?.users?[userIndex] = user;
    notifyListeners();
  }
}
