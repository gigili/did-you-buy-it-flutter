import 'package:did_you_buy_it/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 75,
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: paddingMedium,
                  child: TextFormField(
                    decoration: defaultInputDecoration("Username", "Username"),
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
                  padding: paddingMedium,
                  child: TextFormField(
                    obscureText: true,
                    decoration: defaultInputDecoration("Password", "Password"),
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
                  padding: paddingMedium,
                  child: RoundedButtonWidget(
                    label: "LOGIN",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
