import 'package:did_you_buy_it/ui/form/auth/login_form.dart';
import 'package:did_you_buy_it/ui/screens/auth/password_reset.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          LoginForm(),
          Spacer(flex: 12),
          Divider(thickness: 2),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ResetPassword.routeName);
            },
            child: Container(
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
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
