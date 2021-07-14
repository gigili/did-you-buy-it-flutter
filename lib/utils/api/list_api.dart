import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/api/api_result.dart';
import 'package:did_you_buy_it/utils/models/list_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListApi {
  static SharedPreferences? _preferences;

  static Future<ApiResult<ListApiResult>> getLists(
    int page, {
    int limit = 10,
  }) async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    String? token = _preferences!.getString(ACCESS_TOKEN_KEY);

    if (token == null) {
      return ApiResult(status: ListApiResult.InvalidToken);
    }

    Response result = await callAPI(
      "/list?limit=$limit&page=$page",
      requestMethod: RequestMethod.GET,
      headers: {"Authorization": "Bearer $token"},
    );

    var res = jsonDecode(result.body);
    if (result.statusCode == 200) {
      if (res["data"].length == 0) {
        return ApiResult(status: ListApiResult.NoMoreResults);
      }

      return ApiResult.fromResponse(result, ListApiResult.OK);
    } else {
      return ApiResult.fromResponse(result, ListApiResult.FailedLoadingLists);
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

enum ListApiResult {
  OK,
  InvalidToken,
  FailedLoadingLists,
  NoMoreResults,
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
