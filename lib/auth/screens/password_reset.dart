import 'package:did_you_buy_it/auth/api/auth_api.dart';
import 'package:did_you_buy_it/auth/forms/password_reset_form.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
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
        title: Text(APP_NAME),
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
                              onCodeChanged: (value) =>
                                  passwordResetCode = value,
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

  void requestPasswordReset() async {
    try {
      setState(() {
        apiCallInProgress = true;
      });

      var result = await AuthApi.requestPasswordReset(emailOrUsername);
      if (result) {
        showMsgDialog(
          context,
          title: "Success",
          message: "We sent an email with code to reset your password.",
        );

        showPasswordResetForm = true;
      } else {
        showMsgDialog(
          context,
          title: "Error",
          message: "Unable to send password reset link.",
        );
        showPasswordResetForm = false;
      }
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error",
        message: "Unable to send password reset link.",
      );

      showPasswordResetForm = false;
    } finally {
      setState(() {
        apiCallInProgress = false;
      });
    }
  }

  void resetPassword() async {
    try {
      setState(() {
        apiCallInProgress = true;
      });

      await AuthApi.resetPassword(
        passwordResetCode: passwordResetCode,
        newPassword: newPassword,
      );

      showMsgDialog(
        context,
        title: "Password changed",
        message: "Password reset successfully\nYou can login now.",
        callBack: () {
          Navigator.of(context).pop();
        },
      );
      showPasswordResetForm = false;
    } catch (_) {
      showMsgDialog(
        context,
        title: "Password reset failed",
        message: "Failed to reset password.",
        closeButtonText: "OK",
      );
    } finally {
      setState(() {
        apiCallInProgress = false;
      });
    }
  }
}
