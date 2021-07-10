import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/api/auth_api.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loginInProgress = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                          controller: usernameController,
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
                        ),
                      ),
                      Padding(
                        padding: paddingMediumAll,
                        child: TextFormField(
                          controller: passwordController,
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

  void login() async {
    setState(() {
      loginInProgress = true;
    });

    ApiResult<LoginResult> result = await AuthApi.login(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (result.status == LoginResult.OK) {
      usernameController.clear();
      passwordController.clear();
      Navigator.of(context).pop();
      Navigator.pushNamed(context, ListsScreen.routeName);
    } else {
      var message = result.errorMessage ?? "Login failed";
      var field = result.status == LoginResult.FaildInputValidation
          ? "\nInvalid field: " + (result.errorField ?? "")
          : "";
      showMsgDialog(
        context,
        title: "Login failed",
        message: "$message$field",
        closeButtonText: "OK",
      );
    }

    setState(() {
      loginInProgress = false;
    });
  }
}
