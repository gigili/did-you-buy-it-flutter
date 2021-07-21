import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

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
  Color pickerColor = Color(0xff443a49);
  bool setCustomColor = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: listNameController,
            decoration: defaultInputDecoration("List name", "List name"),
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
              }
            },
          ),
        ],
      ),
    );
  }
}
