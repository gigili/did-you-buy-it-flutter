import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/list_item/api/list_item_api.dart';
import 'package:did_you_buy_it/list_item/components/list_item_header.dart';
import 'package:did_you_buy_it/list_item/components/list_item_tile.dart';
import 'package:did_you_buy_it/list_item/forms/list_item_form.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItems extends StatefulWidget {
  static String routeName = "/listDetails";

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isApiCallInProgress = false;

  @override
  void didChangeDependencies() {
    var list = context.read(listProvider).list;
    if (list == null) Navigator.of(context).pop();
    if (!isApiCallInProgress) loadItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions: [
          IconButton(
            onPressed: () {
              loadItems();
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          ListModel? list = watch(listProvider).list;
          return Column(
            children: [
              ListItemHeader(),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: (list?.items?.length ?? 0),
                  itemBuilder: (context, index) {
                    list = list;
                    if (list?.items == null || list!.items!.isEmpty) {
                      return SizedBox();
                    }

                    if (index >= (list?.items?.length ?? 0)) return SizedBox();

                    ListItemModel? item = list?.items?.elementAt(index);

                    return ListItemTile(item: item!);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white70,
        onPressed: () {
          Navigator.of(context).pushNamed(ListItemForm.route_name, arguments: {
            "listID": context.read(listProvider).list?.id,
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void loadItems() async {
    String listID = context.read(listProvider).list!.id;
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(ACCESS_TOKEN_KEY)!;

    if (isApiCallInProgress) return;
    isApiCallInProgress = true;

    try {
      List<ListItemModel> items =
          await ListItemApi.getListItems(listID: listID, token: token);

      context.read(listProvider).clearItems();
      context.read(listProvider).addItems(items, shouldClear: true);
      var list = context.read(listProvider).list!;
      context.read(listsProvider).updateList(list);
    } on ListNotFoundException catch (_) {
      Navigator.of(context).pop<ListModel>(context.read(listProvider).list!);
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error loading data",
        message: "Failed to load list data",
      );
    } finally {
      isApiCallInProgress = false;
    }
  }
}
