import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/routes.dart';
import 'package:did_you_buy_it/ui/screens/home_screen.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = (prefs.getString(ACCESS_TOKEN_KEY) != null);
  int lastLogin = prefs.getInt("lastLogin") ?? 0;
  int now = DateTime.now().millisecondsSinceEpoch;
  int diff = now - lastLogin;
  int maxLoginLifeSpan = 3600 * 1000 * 2;
  isLoggedIn = isLoggedIn && (diff < maxLoginLifeSpan);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Did You Buy It?",
      routes: routes,
      theme: ThemeData.dark(),
      home: isLoggedIn ? ListsScreen() : HomeScreen(),
    ),
  );
}
