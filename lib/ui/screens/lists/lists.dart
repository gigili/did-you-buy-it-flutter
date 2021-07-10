import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists_view_tile.dart';
import 'package:did_you_buy_it/ui/screens/lists_items/list_items.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
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
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: ListView.builder(
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
              if (index >= (lists.length - 1)) {
                loadLists();
              }

              return ListTile(
                title: ListsViewTile(
                  item: lists[index],
                  onDeleteList: (ListModel itemToDelete) {
                    deleteList(itemToDelete);
                  },
                ),
                onTap: () {
                  viewList(index);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () async {
          String? listName = await prompt(
            context,
            title: Text("Create new list"),
            textOK: Text("Create list"),
            textCancel: Text("Cancle"),
            hintText: "Enter name for a new list",
          );

          if (listName == null || listName.isEmpty) {
            return showMsgDialog(context, message: 'List name can\'t be empty');
          }

          createList(listName);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void viewList(int index) async {
    final result = await Navigator.pushNamed(
      context,
      ListItems.routeName,
      arguments: lists[index],
    ) as ListModel?;

    if (result != null) {
      setState(() {
        lists.removeWhere((element) => element.id == result.id);
      });
    }
  }

  void loadLists({int limit = 10}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (loadMore) {
      String token = prefs!.getString(ACCESS_TOKEN_KEY)!;

      Response result = await callAPI(
        "/list?limit=$limit&page=$listsPage",
        requestMethod: RequestMethod.GET,
        headers: {"Authorization": "Bearer $token"},
      );

      var res = jsonDecode(result.body);
      if (result.statusCode == 200) {
        if (res["data"].length == 0) {
          loadMore = false;
          return;
        }

        List<ListModel> _ll = [];
        for (var row in res["data"]) {
          _ll.add(ListModel.fromMap(row));
        }

        setState(() {
          lists.addAll(_ll);
          listsPage++;
        });
      } else {
        showMsgDialog(
          context,
          title: "Error",
          message: res["error"]["message"],
        );
      }
    }
  }

  void createList(String listName) async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString(ACCESS_TOKEN_KEY)!;
    callAPI(
      "/list",
      params: {'name': listName},
      callback: (String data) {
        var result = jsonDecode(data);
        if (result["success"]) {
          showMsgDialog(
            context,
            title: "List created",
            message: "$listName was created successfully",
          );

          ListModel list = ListModel.fromMap(result["data"]);
          setState(() {
            lists.insert(0, list);
          });
        }
      },
      errorCallback: (statusCode, data) {
        var result = jsonDecode(data);
        showMsgDialog(
          context,
          title: "Error",
          message: result["error"]["message"],
        );
      },
      requestMethod: RequestMethod.POST,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  void deleteList(ListModel itemToDelete) async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString(ACCESS_TOKEN_KEY)!;
    callAPI(
      "/list/${itemToDelete.id}",
      callback: (String data) {
        var result = jsonDecode(data);
        if (result["success"]) {
          showMsgDialog(
            context,
            title: "List deleted",
            message: "${itemToDelete.name} was deleted successfully",
          );

          setState(() {
            lists.removeWhere((element) => element.id == itemToDelete.id);
          });
        }
      },
      errorCallback: (statusCode, data) {
        var result = jsonDecode(data);
        showMsgDialog(
          context,
          title: "Error",
          message: result["error"]["message"],
        );
      },
      requestMethod: RequestMethod.DELETE,
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
