class DuplicateRegistrationException implements Exception {
  final bool isDuplicateUsername;
  final bool isDuplicateEmail;

  DuplicateRegistrationException({
    this.isDuplicateUsername = false,
    this.isDuplicateEmail = false,
  });
}
