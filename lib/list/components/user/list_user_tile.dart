import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_user_api.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/exceptions/user_not_in_list_exception.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUserTile extends StatefulWidget {
  final UserModel user;

  const ListUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ListUserTileState createState() => _ListUserTileState();
}

class _ListUserTileState extends State<ListUserTile> {
  String? sessionUserID;
  late SharedPreferences prefs;
  ListModel? list;

  @override
  void didChangeDependencies() {
    list = context.read(listProvider).list;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadSessionData();
    });
    super.initState();
  }

  void loadSessionData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionUserID = prefs.getString("user_id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.user.image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(paddingLarge),
                child: Image(
                  image: NetworkImage("$BASE_URL ${widget.user.image}"),
                  width: 60,
                  height: 60,
                ),
              )
            : Icon(Icons.person),
        Column(
          children: [
            Text(widget.user.name),
            Text(widget.user.username),
          ],
        ),
        showDeleteIcon()
            ? IconButton(
                onPressed: confirmListDeletion, icon: Icon(Icons.delete))
            : SizedBox(width: paddingMedium),
      ],
    );
  }

  bool showDeleteIcon() {
    var usersInList = context.read(listProvider).list?.users;
    if (usersInList == null) return false;

    var userInList = usersInList.contains(widget.user);
    if (!userInList) return false;

    var isListOwner = ((list?.owner?.id ?? "") == sessionUserID);
    var isLoggedInUser = widget.user.id == sessionUserID;

    if (isListOwner && isLoggedInUser) return false;
    if (isListOwner && !isLoggedInUser) return true;
    if (!isListOwner && isLoggedInUser) return true;

    return false;
  }

  void confirmListDeletion() async {
    showConfirmationDialog(
      context,
      title: "Confirm deletion",
      content:
          "Are you sure you want to delete ${widget.user.name} from the list?",
      positiveButtonAccent: true,
      positiveCallback: () {
        deleteUserFromList();
      },
    );
  }

  void deleteUserFromList() async {
    var list = context.read(listProvider).list;
    var token = prefs.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    try {
      await ListUserApi.removeUserFromList(
        listID: list!.id,
        userID: widget.user.id,
        token: token,
      );

      showMsgDialog(
        context,
        title: "User removed",
        message: "User ${widget.user.name} has been removed from the list.",
        callBack: () {
          if (widget.user.id != sessionUserID) {
            context.read(listProvider).deleteUser(widget.user);
            context.read(listsProvider).updateList(list);
          } else {
            context.read(listsProvider).deleteList(list);
            Navigator.of(context).pop();
          }
        },
      );
    } on UserNotInListException catch (_) {
      showMsgDialog(
        context,
        message: "User not present in the list.",
      );

      var users = list?.users?.where((element) => element.id != widget.user.id);
      if (list != null && users != null) {
        list.users = users.toList();
        list.cntUsers -= 1;
        context.read(listProvider).setList(list);
        context.read(listsProvider).updateList(list);
      }
    } on ListNotFoundException catch (_) {
      showMsgDialog(
        context,
        message: "The list was not found.",
        callBack: () {
          if (list != null) context.read(listsProvider).deleteList(list);
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      print(e);
      showMsgDialog(
        context,
        message: "Unable to remove the user from a list.",
      );
    }
  }
}
