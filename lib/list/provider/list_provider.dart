import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listProvider = ChangeNotifierProvider((ref) => ListProvider());

class ListProvider extends ChangeNotifier {
  ListModel? _list;

  ListModel? get list => _list;

  void setList(ListModel? list) {
    _list = list;
    //notifyListeners();
  }
}
