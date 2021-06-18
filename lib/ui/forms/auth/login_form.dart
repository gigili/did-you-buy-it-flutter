import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/screens/lists/main.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loginInProgress = false;
  final _formKey = GlobalKey<FormState>();
  String? username = "";
  String? password = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 75,
      child: Form(
        key: _formKey,
        child: Center(
          child: !loginInProgress
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: paddingMediumAll,
                        child: TextFormField(
                          decoration:
                              defaultInputDecoration("Username", "Username"),
                          autofocus: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid username';
                            }

                            if (value.length < 3) {
                              return "Username must be at least 3 character";
                            }
                            return null;
                          },
                          onSaved: (value) => username = value,
                        ),
                      ),
                      Padding(
                        padding: paddingMediumAll,
                        child: TextFormField(
                          obscureText: true,
                          decoration:
                              defaultInputDecoration("Password", "Password"),
                          autofocus: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can't be empty";
                            }

                            if (value.length < 8) {
                              return "Password needs to be at least 8 characters";
                            }

                            return null;
                          },
                          onSaved: (value) => password = value,
                        ),
                      ),
                      Padding(
                        padding: paddingMediumAll,
                        child: RoundedButtonWidget(
                          label: "LOGIN",
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  void login() {
    setState(() {
      loginInProgress = true;
    });

    callAPI(
      "/login",
      params: {"username": username, "password": hashStr(password!)},
      callback: (String data) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var result = jsonDecode(data);
        var res = result["data"];
        await prefs.setString(ACCESS_TOKEN_KEY, res["access_token"]);
        await prefs.setString(REFRESH_TOKEN_KEY, res["refresh_token"]);
        await prefs.setInt("lastLogin", DateTime.now().millisecondsSinceEpoch);

        Navigator.of(context).pop();
        Navigator.pushNamed(context, ListsScreen.routeName);
      },
      errorCallback: (int statusCode, String data) {
        var result = jsonDecode(data);
        showMsgDialog(context,
            title: "Login failed",
            message: result["error"]["message"],
            closeButtonText: "OK");
      },
      requestMethod: RequestMethod.POST,
    );

    setState(() {
      loginInProgress = false;
    });
  }
}
