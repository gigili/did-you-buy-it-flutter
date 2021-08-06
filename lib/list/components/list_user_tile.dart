import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_user_api.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUserTile extends StatefulWidget {
  final UserModel user;
  final UserModel? owner;

  const ListUserTile({
    Key? key,
    required this.user,
    this.owner,
  }) : super(key: key);

  @override
  _ListUserTileState createState() => _ListUserTileState();
}

class _ListUserTileState extends State<ListUserTile> {
  String? sessionUserID;
  late SharedPreferences prefs;

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
        //TODO: reconsider the logic for allowing users to remove them self from a list without the owner
        ((widget.owner?.id ?? "") == sessionUserID &&
                widget.user.id != sessionUserID)
            ? IconButton(
                onPressed: deleteUserFromList, icon: Icon(Icons.delete))
            : SizedBox(width: paddingMedium),
      ],
    );
  }

  void deleteUserFromList() async {
    //TODO: add confirmation dialog before deleting a user
    var list = context.read(listProvider).list;
    var token = prefs.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    //TODO: Handle all the individual exceptions
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
      );

      var users = list.users?.where((element) => element.id != widget.user.id);
      list.users = users?.toList();
      list.countUsers -= 1;
      context.read(listProvider).setList(list);
      context.read(listsProvider).updateList(list);
    } catch (_) {
      showMsgDialog(context, message: "Unable to remove the user from a list.");
    }
  }
}
