import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String username;
  String? image;
  String? status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.image,
    this.status,
  });

  static UserModel fromJSON(String data) {
    var res = jsonDecode(data);
    return UserModel(
      id: res["id"],
      name: res["name"],
      email: res["email"],
      username: res["username"],
    );
  }

  @override
  String toString() {
    return name;
  }


}
