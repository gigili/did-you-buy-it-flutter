import 'package:did_you_buy_it/auth/api/auth_api.dart';
import 'package:did_you_buy_it/auth/exceptions/invalid_credentials_exception.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/screens/lists.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/service_unavailable_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loginInProgress = true;
    });

    try {
      LoginResult result = await AuthApi.login(
        username: usernameController.text,
        password: passwordController.text,
      );

      //Store token data into SharedPrefrences
      await prefs.setString(ACCESS_TOKEN_KEY, result.tokens.accessToken);
      await prefs.setString(
          REFRESH_TOKEN_KEY, result.tokens.refreshToken ?? "");
      await prefs.setInt("lastLogin", DateTime.now().millisecondsSinceEpoch);

      //Store user data into SharedPrefrences
      await prefs.setString("user_id", result.user.id);
      await prefs.setString("user_name", result.user.name);
      await prefs.setString("user_email", result.user.email);
      await prefs.setString("user_username", result.user.username);
      await prefs.setString("user_image", result.user.image ?? "");

      usernameController.clear();
      passwordController.clear();

      Navigator.of(context).pop();
      Navigator.pushNamed(context, ListsScreen.routeName);
    } on InvalidCredentialsException catch (_) {
      showMsgDialog(
        context,
        title: "Login failed",
        message: "Invalid credentials",
      );
    } on FailedInputValidationException catch (e) {
      showMsgDialog(
        context,
        title: "Login failed",
        message: "Invalid value provided for ${e.field}",
      );
    } on ServiceUnavailableException catch (_) {
      showMsgDialog(
        context,
        title: "Service status",
        message: "Service unavailable",
      );
    } catch (_) {
      showMsgDialog(
        context,
        title: "Login failed",
        message: "There was an error while logging in",
      );
    } finally {
      setState(() {
        loginInProgress = false;
      });
    }
  }
}
