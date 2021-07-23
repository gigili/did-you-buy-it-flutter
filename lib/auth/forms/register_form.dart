import 'package:did_you_buy_it/auth/api/auth_api.dart';
import 'package:did_you_buy_it/auth/exceptions/duplicate_registration_exception.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/service_unavailable_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Form(
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

                          if (!value.contains("@") ||
                              !emailRegex.hasMatch(value)) {
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
                      padding: paddingMediumAll,
                      child: TextFormField(
                        controller: passwordController,
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
                          _formKey.currentState!.save();
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
    setState(() {
      loading = true;
    });

    try {
      await AuthApi.register(
        name: nameController.text,
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text,
      );

      showMsgDialog(
        context,
        title: "Registration successfull",
        message: "Account registered successfully.\nPlease confirm your email.",
      );

      nameController.clear();
      emailController.clear();
      usernameController.clear();
      passwordController.clear();
    } on DuplicateRegistrationException catch (e) {
      String duplicateField = e.isDuplicateEmail ? "email" : "username";
      showMsgDialog(
        context,
        title: "Registration failed",
        message: "Value for $duplicateField already exists",
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
    } catch (e) {
      showMsgDialog(
        context,
        title: "Registration failed",
        message: e.toString().isNotEmpty
            ? e.toString()
            : "There was an error registering an account",
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
