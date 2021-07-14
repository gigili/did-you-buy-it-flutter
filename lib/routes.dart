import 'package:did_you_buy_it/auth/screens/login_screen.dart';
import 'package:did_you_buy_it/list/screens/lists.dart';
import 'package:did_you_buy_it/ui/screens/auth/password_reset.dart';
import 'package:did_you_buy_it/ui/screens/auth/register_screen.dart';
import 'package:did_you_buy_it/ui/screens/lists_items/list_items.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  ResetPassword.routeName: (context) => ResetPassword(),
  ListsScreen.routeName: (context) => ListsScreen(),
  ListItems.routeName: (context) => ListItems()
};
