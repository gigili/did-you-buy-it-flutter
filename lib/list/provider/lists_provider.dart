import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listsProvider = ChangeNotifierProvider((ref) => ListsProvider());

class ListsProvider extends ChangeNotifier {
  bool _loadInProgress = true;
  List<ListModel> _lists = [];

  List<ListModel> get lists => _lists;

  bool get isLoading => _loadInProgress;

  void addList(ListModel list, {bool asFirst = false}) {
    if (!asFirst)
      _lists.add(list);
    else
      _lists.insert(0, list);

    notifyListeners();
  }

  void addLists(List<ListModel> lists) {
    _lists.addAll(lists);
    notifyListeners();
  }

  void updateList(ListModel list) {
    var index = _lists.indexWhere((element) => element.id == list.id);
    if (index == -1) return;

    _lists[index] = list;
    notifyListeners();
  }

  void deleteList(ListModel list) {
    _lists.remove(list);
    notifyListeners();
  }

  void setLoadingState({bool? loadingState}) {
    if (loadingState != null)
      _loadInProgress = loadingState;
    else
      _loadInProgress = !_loadInProgress;

    notifyListeners();
  }
}
