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

  factory UserModel.fromMap(Map data) {
    return UserModel(
      id: data["id"],
      name: data["name"],
      email: data["email"],
      username: data["username"],
    );
  }

  @override
  String toString() {
    return name;
  }
}
