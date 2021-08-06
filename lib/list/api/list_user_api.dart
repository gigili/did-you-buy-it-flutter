import 'dart:convert';

import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/list/exceptions/action_not_allowed_exception.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/list/exceptions/user_already_in_list_exception.dart';
import 'package:did_you_buy_it/list/exceptions/user_not_in_list_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/unauthorized_exception.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';

class ListUserApi {
  static Future<List<UserModel>> loadListUsers({
    required String listID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/$listID/user",
      headers: {"Authorization": "Bearer $token"},
    );

    switch (response.statusCode) {
      case 401:
        throw InvalidTokenException();
      case 400:
        String errorField = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(errorField);
      case 404:
        throw ListNotFoundException();
      case 500:
        String errorMessage = jsonDecode(response.body)["error"]["message"];
        throw Exception(errorMessage);
      case 200:
      default:
        var data = jsonDecode(response.body)["data"];
        List<UserModel> users = [];
        for (var user in data) {
          users.add(UserModel.fromMap(user));
        }

        return users;
    }
  }

  static Future<List<UserModel>> findUser(
    String searchValue, {
    required String token,
  }) async {
    Response response = await callAPI(
      "/user/find",
      params: {"search": searchValue, "start": "0", "limit": "20"},
      headers: {"Authorization": "Bearer $token"},
      requestMethod: RequestMethod.POST,
    );

    switch (response.statusCode) {
      case 401:
        throw InvalidTokenException();
      case 400:
        var errorField = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(errorField);
      case 500:
        var errorMessage = jsonDecode(response.body)["error"]["message"];
        throw Exception(errorMessage);
      case 200:
      default:
        var data = jsonDecode(response.body)["data"];
        List<UserModel> users = [];
        for (var row in data) {
          users.add(UserModel.fromMap(row));
        }
        return users;
    }
  }

  static Future<void> removeUserFromList({
    required String listID,
    required String userID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/$listID/user/$userID",
      headers: {"Authorization": "Bearer $token"},
      requestMethod: RequestMethod.DELETE,
    );

    switch (response.statusCode) {
      case 400:
        var errorField = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(errorField);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw UnauthroziedException();
      case 404:
        throw ListNotFoundException();
      case 405:
        throw ActionNotAllowedException();
      case 409:
        throw UserNotInListException();
      case 500:
        var errorMessage = jsonDecode(response.body)["error"]["message"];
        throw Exception(errorMessage);
    }
  }

  static Future<UserModel> addUserToList({
    required String listID,
    required String userID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/$listID/user",
      params: {"userID": userID},
      headers: {"Authorization": "Bearer $token"},
      requestMethod: RequestMethod.POST,
    );

    switch (response.statusCode) {
      case 400:
        var errorField = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(errorField);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw UnauthroziedException();
      case 404:
        throw ListNotFoundException();
      case 405:
        throw ActionNotAllowedException();
      case 409:
        throw UserAlreadyInList();
      case 500:
        var errorMessage = jsonDecode(response.body)["error"]["message"];
        throw Exception(errorMessage);

      case 201:
      default:
        var res = jsonDecode(response.body);
        return UserModel.fromMap(res["data"]);
    }
  }
}
