import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
