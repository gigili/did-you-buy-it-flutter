import 'package:did_you_buy_it/ui/screens/auth/login_screen.dart';
import 'package:did_you_buy_it/ui/screens/auth/password_reset.dart';
import 'package:did_you_buy_it/ui/screens/auth/register_screen.dart';
import 'package:did_you_buy_it/ui/screens/lists/lists.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  ResetPassword.routeName: (context) => ResetPassword(),
  ListsScreen.routeName: (context) => ListsScreen()
};
