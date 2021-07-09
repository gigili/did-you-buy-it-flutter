import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/api/auth_api.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  controller: nameController,
                  decoration: defaultInputDecoration("Name", "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  controller: emailController,
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
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  controller: usernameController,
                  decoration: defaultInputDecoration("Username", "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username can't be empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: paddingMediumAll,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: defaultInputDecoration("Password", "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    }
                    return null;
                  },
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

  void register() async {
    RegisterResult result = await AuthApi.register(
      name: nameController.text,
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
    );

    switch (result) {
      case RegisterResult.OK:
        showMsgDialog(
          context,
          title: "Registration successfull",
          message:
              "Account registered successfully.\nPlease confirm your email.",
        );
        break;
      case RegisterResult.FaildInputValidation:
        showMsgDialog(
          context,
          title: "Registration failed",
          message: "Missing required fields",
          closeButtonText: "OK",
        );
        break;
      case RegisterResult.RegistrationFailed:
        showMsgDialog(
          context,
          title: "Registration failed",
          message: "Registration failed",
          closeButtonText: "OK",
        );
        break;
      case RegisterResult.UsernameTaken:
        showMsgDialog(
          context,
          title: "Registration failed",
          message: "Username is already taken",
          closeButtonText: "OK",
        );
        break;
      case RegisterResult.EmailTaken:
        showMsgDialog(
          context,
          title: "Registration failed",
          message: "Email is already taken",
          closeButtonText: "OK",
        );
        break;
    }
  }
}
