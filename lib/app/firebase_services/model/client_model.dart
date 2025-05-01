class ClientModel {
  final String uid;
  final String lineId;
  final String name;
  final String phone;
  final String marketId;

  ClientModel({
    required this.uid,
    required this.lineId,
    required this.name,
    required this.phone,
    required this.marketId,
  });

  factory ClientModel.fromMap(Map<String, dynamic> data) {
    return ClientModel(
      uid: data['uid'] ?? '',
      lineId: data['lineId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      marketId: data['marketId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lineId': lineId,
      'name': name,
      'phone': phone,
      'marketId': marketId,
    };
  }
}
