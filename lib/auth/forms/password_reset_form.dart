import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';

class PasswordResetForm extends StatelessWidget {
  final Function(String val) onCodeChanged;
  final Function(String val) onPasswordChange;

  const PasswordResetForm({
    Key? key,
    required this.onCodeChanged,
    required this.onPasswordChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: defaultInputDecoration("Reset code", "Reset code"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Invalid reset code";
              }
            },
            onChanged: (val) {
              onCodeChanged(val);
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: defaultInputDecoration("New password", "New password"),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Invalid password";
              }

              if (value.length < 8) {
                return "Password must be at least 8 characters";
              }
            },
            onChanged: (value) {
              onPasswordChange(value);
            },
          )
        ],
      ),
    );
  }
}
