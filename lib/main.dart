import 'package:did_you_buy_it/screens/auth/login_screen.dart';
import 'package:did_you_buy_it/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Did You Buy It?",
        home: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Did You Buy It?"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Login"),
                  Tab(text: "Register"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),
              ],
            ),
          ),
        ),
      ),
    );
