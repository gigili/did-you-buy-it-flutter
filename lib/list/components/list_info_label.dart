import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';

class ListInfoLabel extends StatelessWidget {
  final String label;
  final Color fontColor;
  final bool isPrimary;
  const ListInfoLabel({
    Key? key,
    required this.label,
    required this.fontColor,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: isPrimary
          ? accentElementStyle.copyWith(color: fontColor)
          : TextStyle(color: fontColor),
    );
  }
}
