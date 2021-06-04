import 'package:did_you_buy_it/form/auth/register_form.dart';
import 'package:did_you_buy_it/widgets/auth_app_bar.dart';
import 'package:did_you_buy_it/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: authAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 20),
            child: AuthHeader(isLogin: false),
          ),
          RegisterForm(),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
