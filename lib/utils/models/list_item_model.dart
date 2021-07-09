import 'dart:convert';

class ListItemModel {
  String id;
  String listID;
  String userID;
  String? purchasedUserID;
  String name;
  String? image;
  bool isRepeating;
  String? purchasedAt;

  ListItemModel(
      {required this.id,
      required this.listID,
      required this.userID,
      this.purchasedUserID,
      required this.name,
      this.image,
      this.purchasedAt,
      this.isRepeating = false});

  factory ListItemModel.fromMap(Map data) {
    return ListItemModel(
        id: data["id"],
        listID: data["listid"],
        userID: data["userid"],
        name: data["name"],
        purchasedUserID: data["purchaseduserid"],
        image: data["image"],
        purchasedAt: data["purchased_at"],
        isRepeating: data["is_repeating"]);
  }

  @override
  String toString() {
    return name;
  }

  String toStringDebug() {
    var output = "Item info: [$id | $name]\n";
    output += "Item User: $userID\n";
    output += "Item List: $listID\n";
    output += "Item Image: $image\n";
    output += "Item repeating: $isRepeating\n";
    output += "Item purchased by: $purchasedUserID @ $purchasedAt\n";

    return output;
  }
}
