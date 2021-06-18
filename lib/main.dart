import 'package:did_you_buy_it/routes.dart';
import 'package:did_you_buy_it/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Did You Buy It?",
        routes: routes,
        home: HomeScreen(),
      ),
    );
