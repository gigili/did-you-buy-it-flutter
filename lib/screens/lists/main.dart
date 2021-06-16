import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  ListsScreen({Key? key}) : super(key: key);

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Did You Buy It?"),
        actions: [],
      ),
      body: Center(
        child: Text("WELCOME user"),
      ),
    );
  }
}
