import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String hashStr(String str) {
  var bytes = utf8.encode(str); // data being hashed
  return sha256.convert(bytes).toString();
}

void showMsgDialog(BuildContext context,
    {String title = "Error",
    String message = "There was an error",
    String closeButtonText = "Close",
    Function? callBack}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new ElevatedButton(
            child: new Text(closeButtonText),
            onPressed: () {
              Navigator.of(context).pop();

              if (callBack != null) {
                callBack();
              }
            },
          ),
        ],
      );
    },
  );
}

void showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  String positiveActionLabel = "Yes",
  bool positiveButtonAccent = false,
  Function? positiveCallback,
  String negativeActionLabel = "No",
  Function? negativeCallback,
  bool negativeButtonAccent = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: negativeButtonAccent ? Colors.red : Colors.white,
            ),
            child: new Text(negativeActionLabel),
            onPressed: () {
              Navigator.of(context).pop();
              if (negativeCallback != null) {
                negativeCallback();
              }
            },
          ),
          new ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: positiveButtonAccent ? Colors.red : Colors.white,
            ),
            child: new Text(positiveActionLabel),
            onPressed: () {
              Navigator.of(context).pop();
              if (positiveCallback != null) {
                positiveCallback();
              }
            },
          ),
        ],
      );
    },
  );
}

String formatDate(String dateTime, {DateFormat? format}) {
  if (format == null) {
    format = DateFormat.yMd("en_US");
  }
  return format.format(DateTime.parse(dateTime));
}

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = (prefs.getString(ACCESS_TOKEN_KEY) != null);
  int lastLogin = prefs.getInt("lastLogin") ?? 0;
  int now = DateTime.now().millisecondsSinceEpoch;
  int diff = now - lastLogin;
  int maxLoginLifeSpan = 3600 * 1000 * 2;
  isLoggedIn = isLoggedIn && (diff < maxLoginLifeSpan);

  return isLoggedIn;
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
}
