import 'dart:io';

import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list_item/api/list_item_api.dart';
import 'package:did_you_buy_it/list_item/components/add_edit_item_image_button.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/list_item/provider/list_items_provider.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemForm extends StatefulWidget {
  static const String route_name = "/list_item_form";

  const ListItemForm({Key? key}) : super(key: key);

  @override
  _ListItemFormState createState() => _ListItemFormState();
}

class _ListItemFormState extends State<ListItemForm> {
  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController itemNameController = TextEditingController();
  ListItemModel? item;
  XFile? newItemImage;
  bool isRepeating = false;
  String? listID;

  @override
  void didChangeDependencies() {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      if (args["item"] != null) {
        item = args["item"] as ListItemModel;
      }

      if (args["itemIndex"] != null) {
        item = context.read(listItemsProvider).items[args["itemIndex"]];
      }

      if (args["listID"] != null) {
        listID = args["listID"];
      }

      if (item != null) {
        itemNameController.text = item!.name;
        newItemImage = null;
        isRepeating = item!.isRepeating;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.all(paddingMedium),
          child: Column(
            children: [
              TextFormField(
                controller: itemNameController,
                decoration: defaultInputDecoration("Item name", "Item name"),
                validator: (value) {
                  if (value == null || value.trim().length == 0) {
                    return "Item name can't be empty";
                  }

                  return null;
                },
              ),
              SizedBox(height: paddingSmall),
              Container(
                margin: EdgeInsets.only(right: paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddEditItemImageButton(
                      onCameraPicked: () {
                        addItemImage(ImageSource.camera);
                      },
                      onGalleryPicked: () {
                        addItemImage(ImageSource.gallery);
                      },
                    ),
                    Checkbox(
                      value: isRepeating,
                      onChanged: (val) {
                        setState(() {
                          isRepeating = val!;
                        });
                      },
                    ),
                    Text(
                      "Is repeating?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: paddingMedium),
              if (newItemImage == null && item != null && item?.image != null)
                Image(
                  image: NetworkImage("$BASE_URL${item!.image!}"),
                  height: 200,
                ),
              if (newItemImage != null)
                Image.file(
                  File(newItemImage!.path),
                  height: 200,
                ),
              Spacer(flex: 2),
              RoundedButtonWidget(
                label: "Save",
                onPress: () {
                  if (_key.currentState == null) return;

                  if (_key.currentState!.validate()) {
                    _key.currentState!.save();
                    saveItem();
                  }
                },
              ),
              SizedBox(height: paddingMedium)
            ],
          ),
        ),
      ),
    );
  }

  void addItemImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        newItemImage = pickedFile;
      });
    } catch (e) {
      showMsgDialog(context, message: "Unable to add new item image");
    }
  }

  void saveItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;
    if (listID == null) return;

    var itemName = itemNameController.text;
    var isRepeatingItem = isRepeating;

    try {
      await ListItemApi.saveListItem(
        listID: listID!,
        itemID: item?.id,
        name: itemName,
        isRepeating: isRepeatingItem,
        token: token,
        image: newItemImage,
        requestMethod: item == null ? RequestMethod.POST : RequestMethod.PATCH,
      );

      showMsgDialog(
        context,
        title: "Item saved",
        message: "Item saved successfully",
      );
    } catch (_) {
      showMsgDialog(context, message: "Unable to save list item");
    }
  }
}
