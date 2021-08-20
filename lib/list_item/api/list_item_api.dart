import 'dart:convert';

import 'package:did_you_buy_it/list_item/exceptions/list_item_not_found_exception.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/route_not_found_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/unauthorized_exception.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

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

  static Future<ListItemModel> saveListItem({
    required String listID,
    String? itemID,
    required String name,
    required bool isRepeating,
    required String token,
    RequestMethod requestMethod = RequestMethod.POST,
    XFile? image,
  }) async {
    Map<String, String> params = {
      "name": name,
      "is_repeating": isRepeating ? "1" : "0",
    };

    String url = "/list/item/$listID";
    if (itemID != null) url += "/$itemID";

    Response response;

    if (image != null) {
      response = await callAPIFileUpload(
        url,
        file: image,
        params: params,
        requestMethod: requestMethod,
        headers: {"Authorization": "Bearer $token"},
      );
    } else {
      response = await callAPI(
        url,
        params: params,
        requestMethod: requestMethod,
        headers: {"Authorization": "Bearer $token"},
      );
    }

    switch (response.statusCode) {
      case 400:
        var res = jsonDecode(response.body);
        var field = res['error']["field"];
        throw FailedInputValidationException(field);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw UnauthroziedException();
      case 404:
        throw RouteNotFoundException();

      case 200:
      case 201:
      default:
        var res = jsonDecode(response.body);
        return ListItemModel.fromMap(res["data"]);
    }
  }

  static Future<void> deleteListItem({
    required ListItemModel item,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/item/${item.listID}/${item.id}",
      headers: {"Authorization": "Bearer $token"},
      requestMethod: RequestMethod.DELETE,
    );

    switch (response.statusCode) {
      case 400:
        var field = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(field);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw UnauthroziedException();
      case 404:
        throw ListItemNotFoundException();
      case 200:
        break;
      default:
        throw Exception();
    }
  }

  static Future<ListItemModel> updateListItemBoughtState({
    required ListItemModel item,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/item/${item.listID}/${item.id}/bought",
      headers: {"Authorization": "Bearer $token"},
      requestMethod: RequestMethod.PATCH,
    );
    print(response.body);
    switch (response.statusCode) {
      case 400:
        var field = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(field);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw UnauthroziedException();
      case 404:
        throw ListItemNotFoundException();
      case 200:
        var data = jsonDecode(response.body)["data"];
        return ListItemModel.fromMap(data);
      default:
        throw Exception();
    }
  }
}
