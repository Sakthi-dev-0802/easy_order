class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String marketId;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.marketId,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      marketId: data['marketId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'marketId': marketId,
    };
  }
}
