import 'dart:convert';

import 'package:did_you_buy_it/utils/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/models/user_model.dart';

class ListModel {
  String id;
  String userID;
  String name;
  String createdAt;
  int countItems = 0;
  int countUsers = 0;
  int cntBoughtItems = 0;
  List<UserModel>? users;
  List<ListItemModel>? items;

  ListModel({
    required this.id,
    required this.userID,
    required this.name,
    required this.createdAt,
    this.countItems = 0,
    this.countUsers = 0,
    this.cntBoughtItems = 0,
    this.users,
    this.items,
  });

  static ListModel fromJSON(String data) {
    var res = jsonDecode(data);
    List<UserModel> users = [];
    List<ListItemModel> items = [];

    if(res["users"] != null) {
      var usersJson = jsonDecode(res["users"]);
      for (var user in usersJson) {
        users.add(UserModel.fromJSON(user.toString()));
      }
    }

    if(res["items"] != null) {
      var itemsJson = jsonDecode(res["items"]);
      for (var item in itemsJson) {
        items.add(ListItemModel.fromJSON(item.toString()));
      }
    }

    return ListModel(
      id: res["id"],
      userID: res["userid"],
      name: res["name"],
      createdAt: res["created_at"],
      countItems: res["cntitems"],
      countUsers: res["cntusers"],
      cntBoughtItems: res["cntboughtitems"],
      users: users,
      items: items
    );
  }
}
