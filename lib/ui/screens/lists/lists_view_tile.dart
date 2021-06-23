import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:flutter/material.dart';

class ListsViewTile extends StatelessWidget {
  final ListModel item;

  const ListsViewTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items: " + this.item.countItems.toString()),
              Text("Users: " + this.item.countUsers.toString()),
              Text("Bought items: " + this.item.cntBoughtItems.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
