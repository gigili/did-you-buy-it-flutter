import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItemTile extends StatefulWidget {
  final ListItemModel item;
  final String? color;

  const ListItemTile({
    Key? key,
    required this.item,
    this.color,
  }) : super(key: key);

  @override
  _ListItemTileState createState() => _ListItemTileState();
}

class _ListItemTileState extends State<ListItemTile> {
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: widget.color != null ? hexToColor(widget.color!) : Colors.blue,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(paddingMedium),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item.name,
                    style: accentElementStyle,
                  ),
                  if (widget.item.isRepeating) Icon(Icons.refresh)
                ],
              ),
              widget.item.purchasedAt != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Divider(color: Colors.grey[300], thickness: 2),
                        Text(
                            "Bought on: ${formatDate(widget.item.purchasedAt!)}"),
                        Text("Bought by: ${widget.item.purchaseName}"),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
