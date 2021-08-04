import 'dart:convert';

import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/list/exceptions/list_not_found_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/exceptions/invalid_token_exception.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:http/http.dart';

class ListUserApi {
  static Future<List<UserModel>> loadListUsers({
    required String listID,
    required String token,
  }) async {
    Response response = await callAPI(
      "/list/$listID/users",
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
}
