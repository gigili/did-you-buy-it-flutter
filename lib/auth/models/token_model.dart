class TokenModel {
  final String accessToken;
  final String? refreshToken;

  TokenModel({required this.accessToken, this.refreshToken});

  factory TokenModel.fromMap(Map data) {
    return TokenModel(
        accessToken: data["access_token"], refreshToken: data["refresh_token"]);
  }
}
