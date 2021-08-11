import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';

class TypeAheadFieldNoData extends StatelessWidget {
  final String label;

  const TypeAheadFieldNoData({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: paddingSmall),
      margin: EdgeInsets.only(left: 10),
      child: Text(
        this.label,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: Theme.of(context).disabledColor, fontSize: 18.0),
      ),
    );
  }
}
