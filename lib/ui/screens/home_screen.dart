import 'package:did_you_buy_it/ui/screens/auth/login_screen.dart';
import 'package:did_you_buy_it/ui/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }
}
