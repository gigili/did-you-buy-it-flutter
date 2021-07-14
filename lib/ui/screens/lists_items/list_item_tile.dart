import 'dart:convert';

import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItemTile extends StatefulWidget {
  final ListItemModel item;
  final String? strUsers;

  const ListItemTile({Key? key, required this.item, this.strUsers})
      : super(key: key);

  @override
  _ListItemTileState createState() => _ListItemTileState();
}

class _ListItemTileState extends State<ListItemTile> {
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(paddingMedium),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item.name,
                    style: accentElementStyle,
                  ),
                  widget.item.isRepeating
                      ? Icon(
                          Icons.refresh,
                          color: Colors.grey[700],
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(height: 10),
              Text("Qty: //TODO"),
              SizedBox(height: 10),
              widget.item.purchasedAt != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey[300], thickness: 2),
                        Text(
                            "Bought on: ${formatDate(widget.item.purchasedAt!)}"),
                        Text(
                            "Bought by: ${getUserData(widget.item.purchasedUserID)}"),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  UserModel getUserData(String? userID) {
    if (widget.strUsers == null) {
      return UserModel(id: "", name: "", email: "", username: "");
    }

    if (users.length == 0) {
      var usersJSON = jsonDecode(widget.strUsers!);
      for (var item in usersJSON) {
        var user = UserModel.fromMap(item);
        users.add(user);
      }
    }

    return users.firstWhere((user) => user.id == userID);
  }
}
