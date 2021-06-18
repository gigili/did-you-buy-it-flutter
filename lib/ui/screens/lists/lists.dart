import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists_view_tile.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsScreen extends StatefulWidget {
  static String routeName = "/lists";

  ListsScreen({Key? key}) : super(key: key);

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<ListModel> lists = [];
  int listsPage = 0;
  bool loadMore = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Did You Buy It?"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: paddingSmall),
            child: IconButton(
              onPressed: () {
                showMsgDialog(context,
                    title: "Work in progress", message: "NOT IMPLEMENTED YET");
              },
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= (lists.length - 1)) {
            loadLists();
          }

          return ListTile(
            title: ListsViewTile(item: lists[index]),
            onTap: () {
              showMsgDialog(context,
                  title: "Work in progress", message: "NOT IMPLEMENTED YET");
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMsgDialog(context,
              title: "Work in progress", message: "NOT IMPLEMENTED YET");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void loadLists() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(ACCESS_TOKEN_KEY)!;
    if (loadMore) {
      callAPI("/list?limit=10&page=$listsPage", callback: (String data) {
        var res = jsonDecode(data);

        if (res["data"].length == 0) {
          setState(() {
            loadMore = false;
          });
          return;
        }

        List<ListModel> _ll = [];
        for (var row in res["data"]) {
          _ll.add(ListModel.fromJSON(jsonEncode(row)));
        }

        setState(() {
          lists.addAll(_ll);
          listsPage++;
        });
      }, errorCallback: (int resultCode, String data) {
        var result = jsonDecode(data);
        showMsgDialog(context, title: "Error", message: result["error"]["message"]);
      },
          requestMethod: RequestMethod.GET,
          headers: {"Authorization": "Bearer $token"});
    }
  }
}
