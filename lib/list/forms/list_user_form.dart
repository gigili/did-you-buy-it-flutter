import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListUserForm extends StatefulWidget {
  const ListUserForm({Key? key}) : super(key: key);

  @override
  _ListUserFormState createState() => _ListUserFormState();
}

class _ListUserFormState extends State<ListUserForm> {
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController listUserController = TextEditingController();

  @override
  void dispose() {
    listUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: TextFormField(
              controller: listUserController,
              decoration: defaultInputDecoration(
                "Username/Name/Email",
                "Search for a user",
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Search value can't be empty";
                }

                return null;
              },
            ),
          ),
          Spacer(flex: 1),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(paddingSmall),
            ),
            child: IconButton(
              splashColor: Theme.of(context).accentColor,
              splashRadius: paddingLarge,
              onPressed: () {
                if (_key.currentState!.validate()) {
                  _key.currentState!.save();

                  showMsgDialog(
                    context,
                    message: "//TODO NOT IMPLEMENTED",
                  );
                }
              },
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
