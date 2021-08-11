import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_user_api.dart';
import 'package:did_you_buy_it/list/components/list_user_tile.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/ui/widgets/type_ahead_field_no_data.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUserForm extends StatefulWidget {
  @override
  _ListUserFormState createState() => _ListUserFormState();
}

class _ListUserFormState extends State<ListUserForm> {
  TextEditingController autoCompleteController = TextEditingController();

  @override
  void dispose() {
    autoCompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingMedium),
      child: TypeAheadField(
        noItemsFoundBuilder: (context) =>
            TypeAheadFieldNoData(label: "No Users Found!"),
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          controller: autoCompleteController,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontStyle: FontStyle.italic),
          decoration: defaultInputDecoration(
            "Name/Username/Email",
            "Search for a user",
          ),
        ),
        suggestionsCallback: (pattern) async {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString(ACCESS_TOKEN_KEY);

            if (token == null) return [];
            if (pattern.isEmpty || pattern.length < 3) return [];

            return await ListUserApi.findUser(pattern.toString(), token: token);
          } catch (e) {
            return [e.toString()];
          }
        },
        itemBuilder: (context, dynamic user) {
          if (user is String) {
            return Text(user);
          }

          var users = context.read(listProvider).list?.users;
          var owner = users?.firstWhere((element) => element.owner == 1);
          return Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: ListUserTile(user: user, owner: owner),
          );
        },
        onSuggestionSelected: (dynamic suggestion) {
          addUserToList(suggestion as UserModel, context);
        },
      ),
    );
  }

  void addUserToList(UserModel user, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(ACCESS_TOKEN_KEY);

    if (token == null) return;
    try {
      var list = context.read(listProvider).list;
      if (list == null) return;

      UserModel newUser = await ListUserApi.addUserToList(
        listID: list.id,
        userID: user.id,
        token: token,
      );

      showMsgDialog(
        context,
        title: "User added",
        message: "User ${user.name} added successfully to the list",
      );

      list.users?.add(newUser);
      list.countUsers += 1;

      context.read(listProvider).setList(list);
      context.read(listsProvider).updateList(list);

      autoCompleteController.text = "";
    } catch (_) {
      showMsgDialog(
        context,
        message: "Failed to add user ${user.name} to the list",
      );
    }
  }
}
