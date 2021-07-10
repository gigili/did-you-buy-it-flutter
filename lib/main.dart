import 'package:did_you_buy_it/routes.dart';
import 'package:did_you_buy_it/ui/screens/home_screen.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Did You Buy It?",
      routes: routes,
      theme: ThemeData.dark(),
      home: await isLoggedIn() ? ListsScreen() : HomeScreen(),
    ),
  );
}
