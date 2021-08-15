import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list_item/components/list_item_purchase_info.dart';
import 'package:did_you_buy_it/list_item/forms/list_item_form.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItemTile extends StatefulWidget {
  final ListItemModel item;

  const ListItemTile({Key? key, required this.item}) : super(key: key);

  @override
  _ListItemTileState createState() => _ListItemTileState();
}

class _ListItemTileState extends State<ListItemTile> {
  List<UserModel> users = [];
  late ListModel? list;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, watch, Widget? child) {
        ListModel? list = watch(listProvider).list;
        return ListTile(
          onLongPress: () {
            Navigator.of(context)
                .pushNamed(ListItemForm.route_name, arguments: {
              "listID": list!.id,
              "item": widget.item,
            });
          },
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: list!.getListColor(),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.image != null)
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Image(
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                              image:
                                  NetworkImage('$BASE_URL${widget.item.image}'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5, top: 5),
                            child: Icon(
                              Icons.zoom_out_map,
                              size: paddingLarge * 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: paddingSmall,
                            left: paddingSmall,
                            right: paddingMedium,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.item.name,
                                style: accentElementStyle.copyWith(
                                  color: list.getFontColor(),
                                ),
                              ),
                              if (widget.item.isRepeating)
                                Icon(
                                  Icons.refresh,
                                  color: list.getFontColor(),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: paddingSmall,
                            right: paddingSmall,
                            bottom: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Divider(color: Colors.grey[300], thickness: 2),
                              Text(
                                "Quantity: 0 //TODO",
                                style: TextStyle(
                                  color: list.getFontColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.item.purchasedAt != null)
                          ListItemPurchaseInfo(item: widget.item)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
