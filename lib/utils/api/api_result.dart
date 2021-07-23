import 'dart:convert';

import 'package:http/http.dart';

class ApiResult<T> {
  final T status;
  Map? data;
  ApiErrorData? error;

  ApiResult({
    required this.status,
    this.data,
    this.error,
  });

  factory ApiResult.fromResponse(Response response, T status) {
    var result = jsonDecode(response.body);

    ApiResult output = ApiResult<T>(
      status: status,
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
