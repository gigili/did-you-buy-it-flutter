import 'package:did_you_buy_it/list/forms/list_user_form.dart';
import 'package:flutter/material.dart';

class ListUserList extends StatelessWidget {
  const ListUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListUserForm(),
        ListUserList(),
      ],
    );
  }
}
