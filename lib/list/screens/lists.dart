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
            builder: (BuildContext context, watch, Widget? child) {
              var lists = watch(listsProvider).lists;
              var isLoadInProgress = watch(listsProvider).isLoading;
              if (isLoadInProgress)
                return CircularProgressIndicator();
              else
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
                          confirmListDeletion(itemToDelete);
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

    var state = context.read(listsProvider);

    String? token = prefs!.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;
    try {
      state.setLoadingState(loadingState: true);
      List<ListModel> result =
          await ListApi.getLists(page: listsPage, token: token, limit: limit);
      listsPage++;
      state.addLists(result);
    } on NoMoreResultsException catch (_) {
      loadMore = false;
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error loading lists",
        message: "There was an error while loading lists",
      );
      loadMore = false;
    } finally {
      state.setLoadingState(loadingState: false);
    }
  }

  void confirmListDeletion(ListModel itemToDelete) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm deletion"),
          content: new Text(
            "Are you sure you want to delete ${itemToDelete.name} list?",
          ),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: new Text("Yes"),
              onPressed: () {
                deleteList(itemToDelete);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteList(ListModel itemToDelete) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String? token = prefs!.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    var state = context.read(listsProvider);
    state.setLoadingState(loadingState: true);
    try {
      await ListApi.deleteList(list: itemToDelete, token: token);
      showMsgDialog(
        context,
        title: "List deleted",
        message: "${itemToDelete.name} was deleted successfully",
      );
      state.deleteList(itemToDelete);
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error deleting a list",
        message: "Unable to delete a list",
      );
    } finally {
      state.setLoadingState(loadingState: false);
    }
  }
}
