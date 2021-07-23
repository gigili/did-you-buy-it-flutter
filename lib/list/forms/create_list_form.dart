import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/api/list_api.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateListForm extends StatefulWidget {
  const CreateListForm({Key? key}) : super(key: key);

  @override
  _CreateListFormState createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController listNameController = TextEditingController();
  CircleColorPickerController colorController =
      CircleColorPickerController(initialColor: Colors.blue);
  Color pickerColor = DEFAULT_LIST_COLOR;
  bool setCustomColor = false;
  bool apiCallInProgress = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: apiCallInProgress
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: listNameController,
                    decoration:
                        defaultInputDecoration("List name", "List name"),
                    validator: (value) {
                      if (value == null || value.trim().length == 0) {
                        return "List name can't be empty";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Switch(
                        value: setCustomColor,
                        onChanged: (val) {
                          setState(() {
                            setCustomColor = val;
                          });
                        },
                      ),
                      Text(
                        "Pick a list color",
                        style: secondaryElementStyle,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  if (setCustomColor)
                    Center(
                      child: CircleColorPicker(
                        onChanged: (color) => pickerColor = color,
                        size: const Size(240, 240),
                        strokeWidth: 4,
                        thumbSize: 36,
                        controller: colorController,
                      ),
                    ),
                  SizedBox(height: 20),
                  RoundedButtonWidget(
                    label: "Create list",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createList();
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }

  void createList() async {
    setState(() {
      apiCallInProgress = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listName = listNameController.text;

    String? token = prefs.getString(ACCESS_TOKEN_KEY);
    if (token == null) return;

    try {
      String? color = setCustomColor
          ? pickerColor.value.toRadixString(16).substring(2)
          : null;
      ListModel list =
          await ListApi.createList(name: listName, token: token, color: color);
      print("List Created");

      showMsgDialog(
        context,
        title: "List created",
        message: "$listName was created successfully",
        callBack: () {
          Navigator.of(context).pop<ListModel>(list);
        },
      );
    } on InvalidTokenException catch (_) {
      showMsgDialog(context,
          title: "Error creating a list",
          message: "Invalid session.\nTry logging in again.");
    } on FailedInputValidationException catch (e) {
      showMsgDialog(
        context,
        title: "Error creating a list",
        message: "Invalid value provided for ${e.field}",
      );
    } catch (_) {
      showMsgDialog(
        context,
        title: "Error creating a list",
        message: "Unable to create a new list",
      );
    } finally {
      setState(() {
        apiCallInProgress = false;
      });
    }
  }
}
