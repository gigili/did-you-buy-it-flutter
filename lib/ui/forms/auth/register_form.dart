import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? name = "";
  String? email = "";
  String? username = "";
  String? password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  decoration: defaultInputDecoration("Name", "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) => name = newValue,
                  onChanged: (newValue) => name = newValue,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  decoration: defaultInputDecoration("Email", "Email"),
                  autofillHints: [AutofillHints.email],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email can't be empty";
                    }

                    if (!value.contains("@") || !emailRegex.hasMatch(value)) {
                      return "Invalid e-mail address";
                    }

                    return null;
                  },
                  onSaved: (newValue) => email = newValue,
                  onChanged: (newValue) => email = newValue,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  decoration: defaultInputDecoration("Username", "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username can't be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) => username = newValue,
                  onChanged: (newValue) => username = newValue,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  obscureText: true,
                  decoration: defaultInputDecoration("Password", "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    }
                    return null;
                  },
                  onSaved: (newValue) => password = newValue,
                  onChanged: (newValue) => password = newValue,
                ),
              ),
            ),
            Container(
              height: 10,
              child: SizedBox(height: 10),
            ),
            Container(
              child: RoundedButtonWidget(
                label: "SIGN UP",
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    callAPI("/register", params: {
      "name": name,
      "email": email,
      "username": username,
      "password": hashStr(password!)
    }, callback: (String data) {
      var result = jsonDecode(data);
      if (result["success"]) {
        showMsgDialog(context,
            title: "Registration successful", message: result["message"]);
      } else {
        showMsgDialog(context,
            title: "Registration failed",
            message: "Unable to register an account");
      }
    }, errorCallback: (int statusCode, String data) {
      var result = jsonDecode(data);
      showMsgDialog(context,
          title: "Registration failed", message: result["error"]["message"]);
    }, requestMethod: RequestMethod.POST);
  }
}
