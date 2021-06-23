import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/list_info_labels.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
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
              GestureDetector(
                onTap: () {
                  showMsgDialog(context, message: "NOT IMPLEMENTED", title: "SETTINGS ICON");
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListInfoLabels(list: this.item),
        ],
      ),
    );
  }
}
