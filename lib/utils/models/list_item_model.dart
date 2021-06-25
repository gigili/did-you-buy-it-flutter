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

  ListItemModel({
    required this.id,
    required this.listID,
    required this.userID,
    this.purchasedUserID,
    required this.name,
    this.image,
    this.purchasedAt,
    this.isRepeating = false
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
      purchasedAt: res["purchased_at"],
      isRepeating: res["is_repeating"]
    );
  }

  @override
  String toString() {
    return name;
  }

  String toStringDebug(){
    var output = "Item info: [$id | $name]\n";
    output += "Item User: $userID\n";
    output += "Item List: $listID\n";
    output += "Item Image: $image\n";
    output += "Item repeating: $isRepeating\n";
    output += "Item purchased by: $purchasedUserID @ $purchasedAt\n";

    return output;
  }
}
