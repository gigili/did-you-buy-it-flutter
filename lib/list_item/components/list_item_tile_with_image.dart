import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list_item/forms/list_item_form.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItemTileWithImage extends StatefulWidget {
  final ListItemModel item;

  const ListItemTileWithImage({Key? key, required this.item}) : super(key: key);

  @override
  _ListItemTileWithImageState createState() => _ListItemTileWithImageState();
}

class _ListItemTileWithImageState extends State<ListItemTileWithImage> {
  List<UserModel> users = [];
  late ListModel? list;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, watch, Widget? child) {
        list = watch(listProvider).list;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage('$BASE_URL${widget.item.image}'),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: paddingMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.item.name,
                          style: accentElementStyle.copyWith(
                            color: list!.getFontColor(),
                          ),
                        ),
                        if (widget.item.isRepeating)
                          Icon(
                            Icons.refresh,
                            color: list!.getFontColor(),
                          )
                      ],
                    ),
                  ),
                  widget.item.purchasedAt != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Divider(color: Colors.grey[300], thickness: 2),
                              Text(
                                "Bought on: ${formatDate(widget.item.purchasedAt!)}",
                                style: secondaryElementStyle.copyWith(
                                  color: list!.getFontColor(),
                                ),
                              ),
                              Text(
                                "Bought by: ${widget.item.purchaseName}",
                                style: secondaryElementStyle.copyWith(
                                  color: list!.getFontColor(),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
