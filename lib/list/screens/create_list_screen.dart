import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/forms/list_form.dart';
import 'package:flutter/material.dart';

class CreateListScreen extends StatelessWidget {
  static String routeName = "/create-list";
  const CreateListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingMedium),
        child: Center(
          child: ListForm(),
        ),
      ),
    );
  }
}
