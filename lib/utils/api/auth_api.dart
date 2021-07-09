import 'dart:convert';

import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/models/token_model.dart';
import 'package:did_you_buy_it/utils/models/user_model.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static Future<LoginResult> login({
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

    if (apiResponse.statusCode >= 400) {
      if (apiResponse.statusCode == 400)
        return LoginResult.FaildInputValidation;
      if (apiResponse.statusCode == 401) return LoginResult.InvalidCredentials;
      return LoginResult.LoginFailed;
    }

    var result = jsonDecode(apiResponse.body);
    if (!result["success"] || result["data"]["user"].toString().isEmpty)
      return LoginResult.LoginFailed;

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

    return LoginResult.OK;
  }

  static Future<RegisterResult> register({
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

    if (statusCode >= 500) return RegisterResult.RegistrationFailed;

    if (statusCode >= 400) {
      if (statusCode == 400) return RegisterResult.FaildInputValidation;
      if (statusCode == 409 && result["error"]["field"] == "username")
        return RegisterResult.UsernameTaken;

      if (statusCode == 409 && result["error"]["field"] == "email")
        return RegisterResult.EmailTaken;
    }

    if (statusCode == 201) return RegisterResult.OK;

    return RegisterResult.RegistrationFailed;
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
