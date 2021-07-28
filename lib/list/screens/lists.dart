import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_api.dart';
import 'package:did_you_buy_it/list/components/lists_view_tile.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/list/screens/create_list_screen.dart';
import 'package:did_you_buy_it/list_item/screens/list_items.dart';
import 'package:did_you_buy_it/utils/exceptions/no_more_results_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsScreen extends StatefulWidget {
  static String routeName = "/lists";

  ListsScreen({Key? key}) : super(key: key);

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
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
                showMsgDialog(
                  context,
                  title: "Work in progress",
                  message: "NOT IMPLEMENTED YET",
                );
              },
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Consumer(
            builder: (BuildContext context,
                T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
              var lists = watch(listsProvider).lists;
              return ListView.builder(
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
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.of(context).pushNamed(CreateListScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void viewList(int index) {
    Navigator.of(context).pushNamed(ListItems.routeName, arguments: index);
  }

  void loadLists({int limit = 10}) async {
    if (!loadMore) return;

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String? token = prefs!.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    try {
      List<ListModel> result =
          await ListApi.getLists(page: listsPage, token: token, limit: limit);
      listsPage++;
      context.read(listsProvider).addLists(result);
    } on NoMoreResultsException catch (_) {
      loadMore = false;
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error loading lists",
        message: "There was an error while loading lists",
      );
    }
  }

  void deleteList(ListModel itemToDelete) async {
    //TODO: Add a confirmation dialog here first
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String? token = prefs!.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    try {
      await ListApi.deleteList(list: itemToDelete, token: token);
      showMsgDialog(
        context,
        title: "List deleted",
        message: "${itemToDelete.name} was deleted successfully",
      );
      context.read(listsProvider).deleteList(itemToDelete);
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error deleting a list",
        message: "Unable to delete a list",
      );
    }
  }
}
