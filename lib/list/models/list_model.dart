import 'dart:convert';

import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';

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
  String? color;

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
    this.color,
  });

  factory ListModel.fromMap(Map data) {
    List<UserModel> users = [];
    List<ListItemModel> items = [];

    if (data["users"] != null) {
      var usersJson = jsonDecode(data["users"]);
      for (var user in usersJson) {
        users.add(UserModel.fromMap(user));
      }
    }

    if (data["items"] != null) {
      var itemsJson = jsonDecode(data["items"]);
      for (var item in itemsJson) {
        items.add(ListItemModel.fromMap(item));
      }
    }

    return ListModel(
      id: data["id"],
      userID: data["userid"],
      name: data["name"],
      createdAt: data["created_at"],
      countItems: data["cntitems"] != null ? data["cntitems"] : 0,
      countUsers: data["cntusers"] != null ? data["cntusers"] : 1,
      cntBoughtItems:
          data["cntboughtitems"] != null ? data["cntboughtitems"] : 0,
      users: users,
      items: items,
      color: data["color"] ?? null,
    );
  }
}
