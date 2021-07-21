import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list_item/api/list_item_api.dart';
import 'package:did_you_buy_it/list_item/components/list_item_tile.dart';
import 'package:did_you_buy_it/list_item/components/list_item_tile_with_image.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:did_you_buy_it/list_item/components/list_item_header.dart';

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
      loadItems(list!.id);
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
                          ? ListItemTileWithImage(
                              item: item,
                              color: list?.color,
                            )
                          : ListItemTile(
                              item: item,
                              color: list?.color,
                            );
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

  void loadItems(String listID) async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(ACCESS_TOKEN_KEY)!;
    if (isApiCallInProgress) return;

    setState(() {
      isApiCallInProgress = true;
    });

    try {
      List<ListItemModel> _items =
          await ListItemApi.getListItems(listID: listID, token: token);

      setState(() {
        items = _items;
      });
    } on ListNotFoundException catch (_) {
      Navigator.of(context).pop<ListModel>(list);
    } on InvalidTokenException catch (_) {} catch (_) {
      showMsgDialog(
        context,
        title: "Error loading data",
        message: "Failed to load list data",
      );
    } finally {
      setState(() {
        isApiCallInProgress = false;
      });
    }
  }
}