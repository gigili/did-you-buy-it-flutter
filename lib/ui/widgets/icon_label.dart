import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final Icon icon;
  final String label;

  const IconLabel({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        SizedBox(width: 10),
        icon,
      ],
    );
  }
}
