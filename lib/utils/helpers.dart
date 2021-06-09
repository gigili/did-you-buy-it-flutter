import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

String hashStr(String str) {
  var bytes = utf8.encode(str); // data being hashed
  return sha256.convert(bytes).toString();
}

void showMsgDialog(BuildContext context, {
  String title = "Error",
  String message = "There was an error",
  String closeButtonText = "Close"
}) {
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
            },
          ),
        ],
      );
    },
  );
}