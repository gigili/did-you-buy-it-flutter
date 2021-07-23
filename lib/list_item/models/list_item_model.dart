class ListItemModel {
  String id;
  String listID;
  String userID;
  String? purchasedUserID;
  String name;
  String? image;
  bool isRepeating;
  String? purchasedAt;
  String? creatorName;
  String? purchaseName;
  String? listName;

  ListItemModel({
    required this.id,
    required this.listID,
    required this.userID,
    this.purchasedUserID,
    required this.name,
    this.image,
    this.purchasedAt,
    this.isRepeating = false,
    this.creatorName,
    this.purchaseName,
    this.listName,
  });

  factory ListItemModel.fromMap(Map data) {
    return ListItemModel(
      id: data["id"],
      listID: data["listid"],
      userID: data["userid"],
      name: data["name"],
      purchasedUserID: data["purchaseduserid"],
      image: data["image"],
      purchasedAt: data["purchased_at"],
      isRepeating: data["is_repeating"],
      creatorName: data["creator_name"],
      listName: data["list_name"],
      purchaseName: data["purchase_name"],
    );
  }

  @override
  String toString() {
    return name;
  }
}
