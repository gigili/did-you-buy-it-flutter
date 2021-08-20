import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableActionWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;
  final bool closeOnTap;
  final Color? color;
  final Color? foregroundColor;

  const SlidableActionWidget({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.closeOnTap = false,
    this.color = Colors.transparent,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(paddingSmall),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(paddingMedium),
        child: IconSlideAction(
          closeOnTap: this.closeOnTap,
          caption: this.label,
          color: this.color,
          foregroundColor: this.foregroundColor,
          icon: this.icon,
          onTap: this.onTap,
        ),
      ),
    );
  }
}
