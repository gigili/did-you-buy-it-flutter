import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/components/list_users_component.dart';
import 'package:did_you_buy_it/list/forms/list_form.dart';
import 'package:flutter/material.dart';

class ListEditingScreen extends StatefulWidget {
  static String routeName = "/edit-list";

  ListEditingScreen({Key? key}) : super(key: key);

  @override
  _ListEditingScreenState createState() => _ListEditingScreenState();
}

class _ListEditingScreenState extends State<ListEditingScreen> {
  String tab = "list";

  @override
  void didChangeDependencies() {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      tab = args["tab"] as String;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: tab == "list" ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit list"),
          bottom: TabBar(
            indicatorColor: Colors.white60,
            tabs: [
              Tab(text: "List info"),
              Tab(text: "Users"),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(paddingMedium),
                  child: ListForm(),
                ),
                ListUsersComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
