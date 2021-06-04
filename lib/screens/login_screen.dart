import 'package:did_you_buy_it/form/auth/login_form.dart';
import 'package:did_you_buy_it/widgets/auth_app_bar.dart';
import 'package:did_you_buy_it/widgets/auth_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: authAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: AuthHeader(isLogin: true),
          ),
          Spacer(flex: 6),
          LoginForm(),
          Spacer(flex: 12),
          Divider(thickness: 3),
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
