import 'package:did_you_buy_it/list/components/list_info_label.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';

class ListInfoLabels extends StatelessWidget {
  final ListModel list;

  const ListInfoLabels({Key? key, required this.list}) : super(key: key);

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
          label: list.countItems.toString(),
          fontColor: list.getFontColor(),
        ),
        ListInfoLabel(
          label: "Users",
          fontColor: list.getFontColor(),
          isPrimary: true,
        ),
        ListInfoLabel(
          label: list.countUsers.toString(),
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
