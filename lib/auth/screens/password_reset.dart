import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/forms/auth/password_reset_form.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  static String routeName = "/reset-password";
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool apiCallInProgress = false;
  bool showPasswordResetForm = false;
  String emailOrUsername = "";
  String passwordResetCode = "";
  String newPassword = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DYBI? - Reset password"),
      ),
      body: !apiCallInProgress
          ? Form(
              key: _formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showPasswordResetForm
                          ? PasswordResetForm(
                              onCodeChanged: (value)  => passwordResetCode = value,
                              onPasswordChange: (value) => newPassword = value,
                            )
                          : TextFormField(
                              decoration: defaultInputDecoration(
                                  "Username or e-mail", "Username or e-mail"),
                              autofocus: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Value can't be empty";
                                }

                                if (value.length < 3) {
                                  return "Value must be at least 3 character";
                                }

                                if (value.contains("@") &&
                                    !emailRegex.hasMatch(value)) {
                                  return "Invalid email address";
                                }
                                return null;
                              },
                              onChanged: (value) => emailOrUsername = value,
                            ),
                      SizedBox(height: 20),
                      RoundedButtonWidget(
                        label: !showPasswordResetForm
                            ? "Request password reset"
                            : "Reset password",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            !showPasswordResetForm
                                ? requestPasswordReset()
                                : resetPassword();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void requestPasswordReset() {
    setState(() {
      apiCallInProgress = true;
    });

    callAPI("/request_reset_password_link",
        params: {"emailOrUsername": this.emailOrUsername},
        callback: (String result) {
      var response = jsonDecode(result);
      if (response["success"]) {
        showMsgDialog(
          context,
          title: "Success",
          message: "We sent an email with code to reset your password.",
        );

        setState(() {
          showPasswordResetForm = true;
        });
      } else {
        showMsgDialog(
          context,
          title: "Error",
          message: "Unable to send password reset link.",
        );

        setState(() {
          showPasswordResetForm = false;
        });
      }
      setState(() {
        apiCallInProgress = false;
      });
    }, errorCallback: (int responseCode, String data) {
      setState(() {
        apiCallInProgress = false;
        showPasswordResetForm = false;
      });

      var result = jsonDecode(data);
      showMsgDialog(
        context,
        title: "Password reset failed",
        message: result["error"]["message"],
        closeButtonText: "OK",
      );
    }, requestMethod: RequestMethod.POST);
  }

  void resetPassword() {
    setState(() {
      apiCallInProgress = true;
    });

    callAPI("/reset_password/$passwordResetCode",
        params: {"password": hashStr(newPassword)}, callback: (String data) {
      var result = jsonDecode(data);

      if (result["success"]) {
        showMsgDialog(context,
            title: "Password changed",
            message: "Password reset succesfully\nYou can login now.");

        setState(() {
          showPasswordResetForm = false;
        });
      }

      setState(() {
        apiCallInProgress = false;
      });
    }, errorCallback: (int responseCode, String data) {
      setState(() {
        apiCallInProgress = false;
      });
      var result = jsonDecode(data);
      showMsgDialog(
        context,
        title: "Password reset failed",
        message: result["error"]["message"],
        closeButtonText: "OK",
      );
    }, requestMethod: RequestMethod.POST);
  }
}
