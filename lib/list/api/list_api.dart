import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/exceptions/failed_loading_lists_exception.dart';
import 'package:did_you_buy_it/utils/api/api_result.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/no_more_results_exception.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListApi {
  static SharedPreferences? _preferences;

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

  static Future<ApiResult<CreateListApiResult>> createList(
      String listName) async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    String? token = _preferences!.getString(ACCESS_TOKEN_KEY);

    if (token == null) {
      return ApiResult(status: CreateListApiResult.InvalidToken);
    }

    Response result = await callAPI(
      "/list",
      params: {'name': listName},
      requestMethod: RequestMethod.POST,
      headers: {"Authorization": "Bearer $token"},
    );

    if (result.statusCode == 201) {
      return ApiResult.fromResponse(result, CreateListApiResult.OK);
    } else if (result.statusCode == 401) {
      return ApiResult.fromResponse(result, CreateListApiResult.InvalidToken);
    } else if (result.statusCode == 400) {
      return ApiResult.fromResponse(
          result, CreateListApiResult.FailedInputValidation);
    }

    return ApiResult.fromResponse(
        result, CreateListApiResult.FailedCreatingList);
  }

  static Future<ApiResult<DeleteListApiResult>> deleteList(
      ListModel list) async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    String? token = _preferences!.getString(ACCESS_TOKEN_KEY);

    if (token == null) {
      return ApiResult(status: DeleteListApiResult.InvalidToken);
    }
    Response response = await callAPI(
      "/list/${list.id}",
      requestMethod: RequestMethod.DELETE,
      headers: {"Authorization": "Bearer $token"},
    );

    switch (response.statusCode) {
      case 200:
        return ApiResult(status: DeleteListApiResult.OK);

      case 400:
        return ApiResult.fromResponse(
            response, DeleteListApiResult.InvalidListID);

      case 401:
        return ApiResult.fromResponse(
            response, DeleteListApiResult.InvalidToken);

      case 403:
        return ApiResult.fromResponse(
            response, DeleteListApiResult.NotAuthorized);

      case 404:
        return ApiResult.fromResponse(
            response, DeleteListApiResult.ListNotFound);
    }

    return ApiResult(status: DeleteListApiResult.OK);
  }
}

enum CreateListApiResult {
  OK,
  InvalidToken,
  FailedInputValidation,
  FailedCreatingList
}

enum DeleteListApiResult {
  OK,
  InvalidToken,
  InvalidListID,
  ListNotFound,
  NotAuthorized
}
