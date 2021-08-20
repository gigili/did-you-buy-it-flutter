import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/components/list_info.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/screens/list_editing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsViewTile extends StatefulWidget {
  final ListModel item;
  final Function(ListModel item) onDeleteList;

  const ListsViewTile({
    Key? key,
    required this.item,
    required this.onDeleteList,
  }) : super(key: key);

  @override
  _ListsViewTileState createState() => _ListsViewTileState();
}

class _ListsViewTileState extends State<ListsViewTile> {
  String sessionUserID = "";

  @override
  void initState() {
    // TODO: implement initState
    setSessionUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.item.getListColor(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.widget.item.name,
                style: TextStyle(
                  color: widget.item.getFontColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              PopupMenuButton(
                tooltip: "List settings",
                elevation: 4,
                child: Icon(
                  Icons.settings,
                  color: widget.item.getFontColor(),
                ),
                onSelected: (String value) {
                  switch (value) {
                    case "EditList":
                      context.read(listProvider).setList(widget.item);
                      Navigator.of(context).pushNamed(
                        ListEditingScreen.routeName,
                        arguments: {"tab": "list"},
                      );
                      break;
                    case "ManageUsers":
                      context.read(listProvider).setList(widget.item);
                      Navigator.of(context).pushNamed(
                        ListEditingScreen.routeName,
                        arguments: {"tab": "user"},
                      );
                      break;
                    case "DeleteList":
                      widget.onDeleteList(widget.item);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    child: Text("Edit list"),
                    value: "EditList",
                  ),
                  const PopupMenuItem(
                    child: Text("Manage users"),
                    value: "ManageUsers",
                  ),
                  if (sessionUserID == widget.item.userID)
                    const PopupMenuItem(
                      child: Text("Delete list"),
                      value: "DeleteList",
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ListInfo(list: this.widget.item),
        ],
      ),
    );
  }

  void setSessionUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionUserID = prefs.getString("user_id") ?? "";
  }
}
