import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItemPurchaseInfo extends ConsumerWidget {
  final ListItemModel item;

  const ListItemPurchaseInfo({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    ListModel list = watch(listProvider).list!;
    return Padding(
      padding: EdgeInsets.only(
        //top: 10,
        left: paddingSmall,
        right: paddingSmall,
        bottom: 10,
      ),
      child: Text(
        "Bought by: ${item.purchaseName} on ${formatDate(item.purchasedAt!)}",
        style: TextStyle(color: list.getFontColor()),
      ),
    );
  }
}
