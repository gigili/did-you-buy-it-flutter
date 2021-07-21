import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/ui/widgets/list_info_labels.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';

class ListsViewTile extends StatelessWidget {
  final ListModel item;
  final Function(ListModel item) onDeleteList;

  const ListsViewTile({
    Key? key,
    required this.item,
    required this.onDeleteList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: item.color != null ? hexToColor(item.color!) : Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              PopupMenuButton(
                tooltip: "List settings",
                elevation: 4,
                child: Icon(
                  Icons.settings,
                  color: Colors.white70,
                ),
                onSelected: (String value) {
                  switch (value) {
                    case "ManageUsers":
                      break;
                    case "DeleteList":
                      onDeleteList(item);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    child: Text("Manage users"),
                    value: "ManagaUsers",
                  ),
                  const PopupMenuItem(
                    child: Text("Delete list"),
                    value: "DeleteList",
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ListInfoLabels(list: this.item),
        ],
      ),
    );
  }
}
