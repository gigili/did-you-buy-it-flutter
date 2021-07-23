import 'dart:convert';

import 'package:did_you_buy_it/list/exceptions/failed_loading_lists_exception.dart';
import 'package:did_you_buy_it/list/exceptions/list_create_failed_exception.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/no_more_results_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/unauthorized_exception.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';

class ListApi {
  static Future<List<ListModel>> getLists({
    required int page,
    required String token,
    int limit = 10,
  }) async {
    Response result = await callAPI(
      "/list?limit=$limit&page=$page",
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );

    var res = jsonDecode(result.body);

    switch (result.statusCode) {
      case 401:
        throw InvalidTokenException();

      case 200:
        if (res["data"].length == 0) throw NoMoreResultsException();

        List<ListModel> lists = [];
        if (res["data"] != null) {
          for (var row in res["data"]) {
            lists.add(ListModel.fromMap(row));
          }
        }

        return lists;

      default:
        throw FailedLoadingListsException();
    }
  }

  static Future<ListModel> createList({
    required String name,
    required String token,
    String? color,
  }) async {
    Map<String, dynamic> params = {"name": name};
    if (color != null) {
      params.addAll({"color": color});
    }

    Response result = await callAPI(
      "/list",
      params: params,
      requestMethod: RequestMethod.POST,
      headers: {"Authorization": "Bearer $token"},
    );

    var res = jsonDecode(result.body);
    if (result.statusCode == 201) {
      return ListModel.fromMap(res["data"]);
    } else if (result.statusCode == 401) {
      throw InvalidTokenException();
    } else if (result.statusCode == 400) {
      throw FailedInputValidationException(res["error"]["field"]);
    }

    throw ListCreateFailedException();
  }

  static Future<void> deleteList({
    required ListModel list,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/${list.id}",
      requestMethod: RequestMethod.DELETE,
      headers: {"Authorization": "Bearer $token"},
    );

    switch (response.statusCode) {
      case 400:
        throw FailedInputValidationException("list ID");

      case 401:
        throw InvalidTokenException();

      case 403:
        throw UnauthroziedException();

      case 404:
        throw ListNotFoundException();
    }
  }

  static Future<ListModel> getList({
    required String listID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/$listID",
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );

    switch (response.statusCode) {
      case 401:
        throw InvalidTokenException();
      case 400:
        throw FailedInputValidationException("listID");
      case 404:
        throw ListNotFoundException();
      case 200:
        var res = jsonDecode(response.body);
        if (res["data"].length == 0) throw NoMoreResultsException();
        return ListModel.fromMap(res['data'][0]);
    }

    throw FailedLoadingListsException();
  }
}
