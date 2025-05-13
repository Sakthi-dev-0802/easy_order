import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String uid;
  final String clientId;
  final String lineId;
  final String marketId;
  final int quantity;
  final DateTime orderDate;

  OrderModel({
    required this.uid,
    required this.clientId,
    required this.lineId,
    required this.marketId,
    required this.quantity,
    required this.orderDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      uid: data['uid'] ?? '',
      clientId: data['clientId'] ?? '',
      lineId: data['lineId'] ?? '',
      marketId: data['marketId'] ?? '',
      quantity: data['quantity'] ?? 0,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'clientId': clientId,
      'lineId': lineId,
      'marketId': marketId,
      'quantity': quantity,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }
}
