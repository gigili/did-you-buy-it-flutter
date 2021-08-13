import 'package:did_you_buy_it/constants.dart';
import 'package:flutter/material.dart';

class AddEditItemImageButton extends StatelessWidget {
  final Function onCameraPicked;
  final Function onGalleryPicked;

  const AddEditItemImageButton({
    Key? key,
    required this.onCameraPicked,
    required this.onGalleryPicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "List settings",
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(paddingMedium),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white70,
            ),
            SizedBox(width: paddingSmall),
            Text("Add/edit item image"),
          ],
        ),
      ),
      onSelected: (String value) {
        switch (value) {
          case "Camera":
            onCameraPicked();
            break;
          case "Gallery":
            onGalleryPicked();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          child: Text("Camera"),
          value: "Camera",
        ),
        const PopupMenuItem(
          child: Text("Gallery"),
          value: "Gallery",
        ),
      ],
    );
  }
}
