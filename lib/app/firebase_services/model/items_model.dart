class ItemsModel {
  final String uid;
  final String itemName;
  int? quantity;
  String? packType;
  int? noOfPack;
  final bool markedForOrder;

  ItemsModel({
    required this.uid,
    required this.itemName,
    this.quantity,
    this.packType,
    this.noOfPack,
    this.markedForOrder = false,
  });

  factory ItemsModel.fromMap(Map<String, dynamic> data) {
    return ItemsModel(
      uid: data['uid'] ?? '',
      itemName: data['item'] ?? '',
      quantity: data['quantity'],
      packType: data['packType'],
      noOfPack: data['noOfPack'],
      markedForOrder: data['markedForOrder'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'item': itemName,
      'quantity': quantity,
      'packType': packType,
      'noOfPack': noOfPack,
      'markedForOrder': markedForOrder,
    };
  }

  ItemsModel copyWith({
    String? uid,
    String? item,
    int? quantity,
    String? packingType,
    int? noOfPack,
    bool? markedForOrder,
  }) {
    return ItemsModel(
      uid: uid ?? this.uid,
      itemName: item ?? itemName,
      quantity: quantity ?? this.quantity,
      packType: packingType ?? packType,
      noOfPack: noOfPack ?? this.noOfPack,
      markedForOrder: markedForOrder ?? this.markedForOrder,
    );
  }
}
