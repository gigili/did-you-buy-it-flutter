import 'package:did_you_buy_it/widgets/rounded_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: paddingMedium,
                    child: TextFormField(
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
                    padding: paddingMedium,
                    child: TextFormField(
                      decoration: defaultInputDecoration("Email", "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email can't be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: paddingMedium,
                    child: TextFormField(
                      decoration:
                          defaultInputDecoration("Username", "Username"),
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
                    padding: paddingMedium,
                    child: TextFormField(
                      obscureText: true,
                      decoration:
                          defaultInputDecoration("Password", "Password"),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
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
