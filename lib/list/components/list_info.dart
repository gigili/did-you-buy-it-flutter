import 'package:did_you_buy_it/list/components/list_info_label.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:flutter/material.dart';

class ListInfo extends StatelessWidget {
  final ListModel list;

  const ListInfo({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ListInfoLabel(
          label: "Items",
          fontColor: list.getFontColor(),
          isPrimary: true,
        ),
        ListInfoLabel(
          label: list.cntItems.toString(),
          fontColor: list.getFontColor(),
        ),
        ListInfoLabel(
          label: "Users",
          fontColor: list.getFontColor(),
          isPrimary: true,
        ),
        ListInfoLabel(
          label: list.cntUsers.toString(),
          fontColor: list.getFontColor(),
        ),
        ListInfoLabel(
          label: "Bought items",
          fontColor: list.getFontColor(),
          isPrimary: true,
        ),
        ListInfoLabel(
          label: list.cntBoughtItems.toString(),
          fontColor: list.getFontColor(),
        ),
      ],
    );
  }
}
