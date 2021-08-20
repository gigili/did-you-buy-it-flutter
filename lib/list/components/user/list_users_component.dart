import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/components/user/list_users_list.dart';
import 'package:did_you_buy_it/list/forms/list_user_form.dart';
import 'package:flutter/material.dart';

class ListUsersComponent extends StatelessWidget {
  const ListUsersComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListUserForm(),
        SizedBox(height: paddingMedium),
        Column(
          children: [
            ListUsersList(),
          ],
        ),
      ],
    );
  }
}
