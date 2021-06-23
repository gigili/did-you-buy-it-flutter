import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String BASE_URL = "http://192.168.0.7:8099";
const String ACCESS_TOKEN_KEY = "API_ACCESS_TOKEN";
const String REFRESH_TOKEN_KEY = "API_REFRESH_TOKEN";
RegExp emailRegex =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

TextStyle primaryElementStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22,
  letterSpacing: 2,
);

TextStyle secondaryElementStyle = TextStyle(
  fontSize: 16,
  letterSpacing: 2,
);

TextStyle accentElementStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

BoxDecoration underlineBoxDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: Colors.blue, style: BorderStyle.solid, width: 4),
  ),
);

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

const paddingSmall = 16.0;
const paddingMedium = 20.0;
const paddingLarge = 30.0;

EdgeInsets paddingSmallAll = const EdgeInsets.fromLTRB(
    paddingSmall, paddingSmall, paddingSmall, paddingSmall);
EdgeInsets paddingMediumAll = const EdgeInsets.fromLTRB(
    paddingMedium, paddingMedium, paddingMedium, paddingMedium);
EdgeInsets paddingLargeAll = const EdgeInsets.fromLTRB(
    paddingLarge, paddingLarge, paddingLarge, paddingLarge);
