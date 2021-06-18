import 'dart:convert';

class ListItemModel {
  String id;
  String listID;
  String userID;
  String? purchasedUserID;
  String name;
  String? image;
  bool isRepeating = false;
  String? purchasedAt;

  ListItemModel({
    required this.id,
    required this.listID,
    required this.userID,
    this.purchasedUserID,
    required this.name,
    this.image,
    this.purchasedAt,
  });

  static ListItemModel fromJSON(String data) {
    var res = jsonDecode(data);
    return ListItemModel(
      id: res["id"],
      listID: res["listid"],
      userID: res["userid"],
      name: res["name"],
      purchasedUserID: res["purchaseduserid"],
      image: res["image"],
      purchasedAt: res["purchased_at"]
    );
  }
}
