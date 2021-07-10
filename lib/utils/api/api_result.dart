class ApiResult<T> {
  final T status;
  final int? statusCode;
  final Map? data;
  final String? errorMessage;
  final String? errorField;
  final String? body;

  ApiResult({
    required this.status,
    this.statusCode,
    this.data,
    this.errorMessage,
    this.errorField,
    this.body,
  });
}
