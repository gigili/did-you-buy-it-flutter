import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String BASE_URL = "http://192.168.0.7:8099";
const String ACCESS_TOKEN_KEY = "API_ACCESS_TOKEN";
const String REFRESH_TOKEN_KEY = "API_REFRESH_TOKEN";
RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

TextStyle primaryElementStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  letterSpacing: 2,
);

TextStyle secondaryElementStyle = TextStyle(
  fontSize: 16,
  letterSpacing: 2,
);

BoxDecoration underlineBoxDecoration = BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.blue, style: BorderStyle.solid, width: 4)));

InputDecoration defaultInputDecoration(String labelText, String hintText,
    {double borderRadius = 10.0}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    labelText: labelText,
    hintText: hintText,
  );
}

EdgeInsets paddingMedium = const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0);