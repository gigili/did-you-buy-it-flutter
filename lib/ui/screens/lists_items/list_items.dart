import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/ui/screens/lists_items/list_item_tile.dart';
import 'package:did_you_buy_it/ui/screens/lists_items/list_item_tile_with_image.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/list_item_header.dart';

class ListItems extends StatefulWidget {
  static String routeName = "/listDetails";

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isApiCallInProgress = false;
  List<ListItemModel>? items;
  String users = "";
  ListModel? list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = ModalRoute.of(context)!.settings.arguments as ListModel;
    if (items == null && !isApiCallInProgress) {
      fetchListData(list!.id);
    }

    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: isApiCallInProgress
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ListItemHeader(list: list!),
                  SizedBox(height: 20),
                  ...List.generate(
                    list!.countItems,
                    (index) {
                      if (items == null || items!.isEmpty) {
                        return SizedBox();
                      }

                      ListItemModel? item = items!.elementAt(index);

                      return item.image != null
                          ? ListItemTileWithImage(item: item)
                          : ListItemTile(item: item, strUsers: users);
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  void fetchListData(String listID) async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(ACCESS_TOKEN_KEY)!;
    if (isApiCallInProgress) return;

    setState(() {
      isApiCallInProgress = true;
    });

    callAPI(
      "/list/$listID",
      callback: (String data) {
        var result = jsonDecode(data);
        List<ListItemModel> itms = [];
        if (result["data"][0]['items'] != null) {
          var itemsJson = jsonDecode(result["data"][0]["items"]);
          for (var item in itemsJson) {
            itms.add(ListItemModel.fromMap(item));
          }
        }

        setState(() {
          if (items == null) {
            items = [];
          }

          if (itms.length > 0) {
            items!.addAll(itms);
          }
          users = result["data"][0]["users"];
          isApiCallInProgress = false;
        });
      },
      errorCallback: (int resultCode, String data) {
        setState(() {
          if (items == null) {
            items = [];
          }
          isApiCallInProgress = false;
        });

        if (resultCode == 404) {
          Navigator.of(context).pop<ListModel>(list);
        }

        var result = jsonDecode(data);
        showMsgDialog(context,
            title: "Error", message: result["error"]["message"]);
      },
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
