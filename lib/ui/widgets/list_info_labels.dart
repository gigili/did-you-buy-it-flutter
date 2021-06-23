import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:flutter/material.dart';

class ListInfoLabels extends StatelessWidget {
  final ListModel list;

  const ListInfoLabels({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Items",
          style: accentElementStyle,
        ),
        Text("${list.countItems}"),
        Text(
          "Users",
          style: accentElementStyle,
        ),
        Text("${list.countUsers}"),
        Text(
          "Bought items",
          style: accentElementStyle,
        ),
        Text("${list.cntBoughtItems}")
      ],
    );
  }
}
