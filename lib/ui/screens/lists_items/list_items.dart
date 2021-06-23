import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/ui/widgets/list_info_labels.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItems extends StatefulWidget {
  static String routeName = "/listDetails";

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isApiCallInProgress = false;
  List<ListItemModel> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListModel? list = ModalRoute.of(context)!.settings.arguments as ListModel;
    if (items.length == 0 && !isApiCallInProgress) {
      fetchListData(list.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Did You Buy It?"),
      ),
      body: isApiCallInProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black)],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          list.name,
                          style: primaryElementStyle,
                        ),
                        SizedBox(height: 20),
                        ListInfoLabels(list: list),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.countItems,
                      itemBuilder: (BuildContext context, int index) {
                        ListItemModel? item = items.elementAt(index);

                        return ListTile(
                          title: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Colors.black,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (item.image != null)
                                    ? Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 120,
                                        height: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Colors.black,
                                              )
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(
                                            "$BASE_URL${item.image}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width * 0.8,
                                        child: Text(item.name)),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Qty: 1"),
                                          Text("Added by: Jane Doe"),
                                          Text("Repeating: No"),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void fetchListData(String listID) async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(ACCESS_TOKEN_KEY)!;
    if (isApiCallInProgress) return;

    setState(() {
      isApiCallInProgress = true;
    });

    callAPI(
      "/list/$listID",
      callback: (String data) {
        setState(() {
          isApiCallInProgress = false;
        });

        var result = jsonDecode(data);
        var itemsJson = jsonDecode(result["data"][0]["items"]);
        List<ListItemModel> itms = [];
        for (var item in itemsJson) {
          itms.add(ListItemModel.fromJSON(jsonEncode(item)));
        }

        if (itms.length > 0) {
          setState(() {
            items.addAll(itms);
          });
        }
      },
      errorCallback: (int resultCode, String data) {
        setState(() {
          isApiCallInProgress = false;
        });

        var result = jsonDecode(data);
        showMsgDialog(context, title: "Error", message: result["error"]["message"]);
      },
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
