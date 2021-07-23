class FailedInputValidationException implements Exception {
  final String field;

  FailedInputValidationException(this.field);
}
