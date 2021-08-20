import 'dart:convert';

import 'package:did_you_buy_it/auth/exceptions/duplicate_registration_exception.dart';
import 'package:did_you_buy_it/auth/exceptions/email_not_sent_exception.dart';
import 'package:did_you_buy_it/auth/exceptions/invalid_credentials_exception.dart';
import 'package:did_you_buy_it/auth/exceptions/login_failed_exception.dart';
import 'package:did_you_buy_it/auth/exceptions/registration_failed_exception.dart';
import 'package:did_you_buy_it/auth/exceptions/user_account_not_found_exception.dart';
import 'package:did_you_buy_it/auth/models/token_model.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:did_you_buy_it/utils/network_utility.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart';

class AuthApi {
  static Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    Response response = await callAPI(
      "/login",
      params: {
        "username": username,
        "password": hashStr(password),
      },
      requestMethod: RequestMethod.POST,
    );

    var result = jsonDecode(response.body);
    int statusCode = response.statusCode;

    switch (statusCode) {
      case 400:
        throw FailedInputValidationException(result["error"]["field"]);
      case 401:
        throw InvalidCredentialsException();
      case 200:
        UserModel user = UserModel.fromMap(result["data"]["user"]);
        TokenModel tokens = TokenModel.fromMap(result["data"]["token"]);
        return LoginResult(user: user, tokens: tokens);
      default:
        throw LoginFailedException();
    }
  }

  static Future<void> register({
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
    print(registerResult.body);
    if (statusCode >= 400) {
      String errorField = result["error"]["field"];

      switch (statusCode) {
        case 500:
          throw RegistrationFailedException();
        case 400:
          throw FailedInputValidationException(result["error"]["field"]);
        case 409:
          throw DuplicateRegistrationException(
            isDuplicateUsername: errorField == "username",
            isDuplicateEmail: errorField == "email",
          );
      }
    }

    if (statusCode != 201) throw RegistrationFailedException();
  }

  static Future<bool> requestPasswordReset(String emailOrUsername) async {
    Response response = await callAPI(
      "/request_reset_password_link",
      params: {"emailOrUsername": emailOrUsername},
      requestMethod: RequestMethod.POST,
    );

    switch (response.statusCode) {
      case 400:
        var field = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(field);
      case 404:
        throw UserAccountNotFoundException();
      case 500:
        throw EmailNotSentException();
    }

    var res = jsonDecode(response.body);
    return res["success"];
  }

  static Future<void> resetPassword({
    required String passwordResetCode,
    required String newPassword,
  }) async {
    Response response = await callAPI(
      "/reset_password/$passwordResetCode",
      params: {"password": hashStr(newPassword)},
      requestMethod: RequestMethod.POST,
    );

    switch (response.statusCode) {
      case 400:
        var field = jsonDecode(response.body)["error"]["field"];
        throw FailedInputValidationException(field);
    }
  }
}

class LoginResult {
  final UserModel user;
  final TokenModel tokens;

  LoginResult({required this.user, required this.tokens});
}
