import 'package:did_you_buy_it/auth/screens/login_screen.dart';
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
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
