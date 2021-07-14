import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_api.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists_view_tile.dart';
import 'package:did_you_buy_it/ui/screens/lists_items/list_items.dart';
import 'package:did_you_buy_it/utils/api/api_result.dart';
import 'package:did_you_buy_it/utils/exceptions/no_more_results_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    if (!loadMore) return;

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String? token = prefs!.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    try {
      List<ListModel> result =
          await ListApi.getLists(page: listsPage, token: token, limit: limit);
      setState(() {
        lists.addAll(result);
        listsPage++;
      });
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

  void createList(String listName) async {
    ApiResult<CreateListApiResult> result = await ListApi.createList(listName);

    switch (result.status) {
      case CreateListApiResult.OK:
        showMsgDialog(
          context,
          title: "List created",
          message: "$listName was created successfully",
        );

        ListModel list = ListModel.fromMap(result.data as Map);
        setState(() {
          lists.insert(0, list);
        });
        break;
      case CreateListApiResult.InvalidToken:
        showMsgDialog(context,
            title: "Error creating a list",
            message: "Invalid session.\nTry logging in again.");
        break;
      case CreateListApiResult.FailedInputValidation:
        var field = "\nInvalid field: " + (result.error?.field ?? "");
        var message = result.error?.message ?? "Invalid value provided";
        showMsgDialog(
          context,
          title: "Error creating a list",
          message: "$message$field",
        );
        break;
      case CreateListApiResult.FailedCreatingList:
        var message = result.error?.message ?? "Unable to create a new list";
        showMsgDialog(
          context,
          title: "Error creating a list",
          message: "$message",
        );
        break;
    }
  }

  void deleteList(ListModel itemToDelete) async {
    ApiResult<DeleteListApiResult> result =
        await ListApi.deleteList(itemToDelete);

    switch (result.status) {
      case DeleteListApiResult.OK:
        showMsgDialog(
          context,
          title: "List deleted",
          message: "${itemToDelete.name} was deleted successfully",
        );

        setState(() {
          lists.removeWhere((element) => element.id == itemToDelete.id);
        });
        break;
      case DeleteListApiResult.InvalidToken:
      case DeleteListApiResult.InvalidListID:
      case DeleteListApiResult.ListNotFound:
      case DeleteListApiResult.NotAuthorized:
        var message = result.error?.message ?? "Unable to delete a list";
        showMsgDialog(
          context,
          title: "Error deleting a list",
          message: message,
        );
        break;
    }
  }
}
