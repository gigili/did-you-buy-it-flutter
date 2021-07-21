import 'dart:convert';

import 'package:did_you_buy_it/list_item/exceptions/list_item_not_found_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/unauthorized_exception.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';

class ListItemApi {
  static Future<List<ListItemModel>> getListItems({
    required String listID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/item/$listID",
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      throw InvalidTokenException();
    } else if (response.statusCode == 403) {
      throw UnauthroziedException();
    } else if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      List<ListItemModel> items = [];
      if (result["data"].length > 0) {
        for (var row in result["data"]) {
          items.add(ListItemModel.fromMap(row));
        }
      }

      return items;
    }

    throw ListItemNotFoundException();
  }
}
