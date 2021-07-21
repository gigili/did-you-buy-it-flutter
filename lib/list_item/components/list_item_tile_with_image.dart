import 'dart:convert';

import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/material.dart';

class ListItemTileWithImage extends StatefulWidget {
  final ListItemModel item;
  final String? strUsers;
  final String? color;

  const ListItemTileWithImage({
    Key? key,
    required this.item,
    this.strUsers,
    this.color,
  }) : super(key: key);

  @override
  _ListItemTileWithImageState createState() => _ListItemTileWithImageState();
}

class _ListItemTileWithImageState extends State<ListItemTileWithImage> {
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: widget.color != null ? hexToColor(widget.color!) : Colors.blue,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage('$BASE_URL${widget.item.image}'),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.name,
                      style: accentElementStyle,
                    ),
                    if (widget.item.isRepeating) Icon(Icons.refresh)
                  ],
                ),
              ),
              widget.item.purchasedAt != null
                  ? Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Divider(color: Colors.grey[300], thickness: 2),
                          Text(
                              "Bought on: ${formatDate(widget.item.purchasedAt!)}"),
                          Text(
                              "Bought by: ${getUserData(widget.item.purchasedUserID)}"),
                        ],
                      ),
                    )
                  : SizedBox(height: 10),
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
