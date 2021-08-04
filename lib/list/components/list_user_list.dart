import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_user_api.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUsersList extends StatefulWidget {
  const ListUsersList({Key? key}) : super(key: key);

  @override
  _ListUsersListState createState() => _ListUsersListState();
}

class _ListUsersListState extends State<ListUsersList> {
  @override
  void initState() {
    loadListUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("List of list users goes here"));
  }

  void loadListUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(ACCESS_TOKEN_KEY) ?? "";

    if (token.isEmpty) return;
    var list = context.read(listProvider).list;

    if (list == null) return;

    try {
      List<UserModel> result =
          await ListUserApi.loadListUsers(listID: list.id, token: token);

      list.users = result;
      context.read(listProvider).setList(list);
    } on InvalidTokenException catch (_) {
      showMsgDialog(
        context,
        message: "Token has expired, please log out and log back in.",
      );
    } on FailedInputValidationException catch (e) {
      showMsgDialog(
        context,
        message: "Invalid value provided for: ${e.field}",
      );
    } on ListNotFoundException catch (_) {
      context.read(listsProvider).deleteList(list);
      context.read(listProvider).setList(null);
      Navigator.of(context).pop();
    } catch (e) {
      showMsgDialog(
        context,
        message: "Unable to load list users",
      );
    }
  }
}
