class UserModel {
  String id;
  String name;
  String email;
  String username;
  String? image;
  String? status;
  int owner;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.image,
    this.status,
    this.owner = 0,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      id: data["id"],
      name: data["name"],
      email: data["email"],
      username: data["username"],
      image: data["image"] ?? null,
      owner: data["owner"] ?? 0,
    );
  }

  @override
  String toString() {
    return name;
  }
}
