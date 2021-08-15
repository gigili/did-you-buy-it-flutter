import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/components/list_info.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:flutter/material.dart';

class ListItemHeader extends StatelessWidget {
  const ListItemHeader({
    Key? key,
    required this.list,
  }) : super(key: key);

  final ListModel list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: list.getListColor(),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black)],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(
            list.name,
            style: primaryElementStyle.copyWith(
              color: list.getFontColor(),
            ),
          ),
          SizedBox(height: 20),
          ListInfo(list: list),
        ],
      ),
    );
  }
}
