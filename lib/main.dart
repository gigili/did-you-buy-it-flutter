import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/routes.dart';
import 'package:did_you_buy_it/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      routes: routes,
      theme: ThemeData(
        colorScheme: ColorScheme.dark().copyWith(primary: Colors.blue),
        primaryColor: Colors.blue[800],
        accentColor: Colors.blue[600],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue[800],
          centerTitle: true,
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
