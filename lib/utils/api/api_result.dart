import 'dart:convert';

import 'package:http/http.dart';

class ApiResult<T> {
  final T status;
  final int? statusCode;
  Map? data;
  ApiErrorData? error;
  final String? body;

  ApiResult({
    required this.status,
    this.statusCode,
    this.data,
    this.error,
    this.body,
  });

  //set error(ApiErrorData? err) => this.error = err;
  //set data(Map? dt) => this.data = dt;

  factory ApiResult.fromResponse(Response response, T status) {
    var result = jsonDecode(response.body);

    ApiResult output = ApiResult<T>(
      status: status,
      statusCode: response.statusCode,
      body: response.body,
    );

    if (result["error"] != null) {
      String? errorMessage = result["error"]?["message"] ?? null;
      String? errorField = result["error"]?["field"] ?? null;
      output.error = ApiErrorData(
        message: errorMessage,
        field: errorField,
      );
    } else {
      output.data = result;
    }

    return output as ApiResult<T>;
  }
}

class ApiErrorData {
  final String? message;
  final String? field;

  ApiErrorData({this.message, this.field});
}
