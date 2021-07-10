import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/api/api_result.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/token_model.dart';
import 'package:did_you_buy_it/utils/models/user_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static Future<ApiResult<LoginResult>> login({
    required String username,
    required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response apiResponse = await callAPI(
      "/login",
      params: {
        "username": username,
        "password": hashStr(password),
      },
      requestMethod: RequestMethod.POST,
    );

    var result = jsonDecode(apiResponse.body);
    int statusCode = apiResponse.statusCode;

    if (statusCode >= 400) {
      String errorMessage = result["error"]["message"];
      String errorField = result["error"]["field"];

      switch (statusCode) {
        case 400:
          return ApiResult(
            status: LoginResult.FaildInputValidation,
            errorMessage: errorMessage,
            errorField: errorField,
          );
        case 401:
          return ApiResult(
            status: LoginResult.InvalidCredentials,
            errorMessage: errorMessage,
            errorField: errorField,
          );
      }

      return ApiResult(status: LoginResult.LoginFailed, body: apiResponse.body);
    }

    if (!result["success"] || result["data"]["user"].toString().isEmpty)
      return ApiResult(status: LoginResult.LoginFailed, body: apiResponse.body);

    UserModel user = UserModel.fromMap(result["data"]["user"]);
    TokenModel tokens = TokenModel.fromMap(result["data"]["token"]);

    //Store token data into SharedPrefrences
    await prefs.setString(ACCESS_TOKEN_KEY, tokens.accessToken);
    await prefs.setString(REFRESH_TOKEN_KEY, tokens.refreshToken ?? "");
    await prefs.setInt("lastLogin", DateTime.now().millisecondsSinceEpoch);

    //Store user data into SharedPrefrences
    await prefs.setString("user_id", user.id);
    await prefs.setString("user_name", user.name);
    await prefs.setString("user_email", user.email);
    await prefs.setString("user_username", user.username);
    await prefs.setString("user_image", user.image ?? "");

    return ApiResult(status: LoginResult.OK);
  }

  static Future<ApiResult<RegisterResult>> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    Response registerResult = await callAPI(
      "/register",
      params: {
        "name": name,
        "email": email,
        "username": username,
        "password": hashStr(password),
      },
      requestMethod: RequestMethod.POST,
    );

    int statusCode = registerResult.statusCode;
    var result = jsonDecode(registerResult.body);

    if (statusCode >= 400) {
      String errorMessage = result["error"]["message"];
      String errorField = result["error"]["field"];

      switch (statusCode) {
        case 500:
          return ApiResult(
            status: RegisterResult.RegistrationFailed,
            statusCode: statusCode,
            errorMessage: errorMessage,
            errorField: errorField,
          );
        case 400:
          return ApiResult(
            status: RegisterResult.FaildInputValidation,
            statusCode: statusCode,
            errorMessage: errorMessage,
            errorField: errorField,
          );
        case 409:
          return ApiResult(
            status: errorField == "username"
                ? RegisterResult.UsernameTaken
                : RegisterResult.EmailTaken,
            statusCode: registerResult.statusCode,
            errorMessage: errorMessage,
            errorField: errorField,
          );
      }
    }

    if (statusCode == 201) return ApiResult(status: RegisterResult.OK);

    return ApiResult(status: RegisterResult.RegistrationFailed);
  }
}

enum LoginResult {
  OK,
  InvalidCredentials,
  FaildInputValidation,
  LoginFailed,
}

enum RegisterResult {
  OK,
  FaildInputValidation,
  RegistrationFailed,
  UsernameTaken,
  EmailTaken,
}
