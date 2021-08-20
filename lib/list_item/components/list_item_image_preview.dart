import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:flutter/material.dart';

class ListItemImagePreview extends StatelessWidget {
  final ListItemModel item;
  const ListItemImagePreview({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Hero(
        tag: "${item.id}-image",
        child: InteractiveViewer(
          minScale: 0.1,
          maxScale: 2,
          panEnabled: true,
          scaleEnabled: true,
          child: Image(
            image: NetworkImage('$BASE_URL${item.image}'),
          ),
        ),
      ),
    );
  }
}
