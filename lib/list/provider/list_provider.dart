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

  void addItems(List<ListItemModel> items) {
    if (_list == null) return;

    if (_list!.items == null) {
      _list!.items = [];
    }

    _list!.items!.addAll(items);
    _list!.cntItems += items.length;
    notifyListeners();
  }

  void deleteItem(ListItemModel item) {
    if (_list == null || _list?.items == null) return;
    _list?.items?.remove(item);
    _list!.cntItems -= 1;
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
}
