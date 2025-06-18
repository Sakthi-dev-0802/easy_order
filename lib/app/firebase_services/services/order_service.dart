import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../base_service.dart';
import '../model/order_model.dart';

class OrderService with FirestoreService {
  OrderService._();
  static final OrderService instance = OrderService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _ordersCollection =
      _firestore.collection('orders');

  Stream<List<OrderModel>> getTodayOrdersByClientId(String clientId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _ordersCollection
        .where('clientId', isEqualTo: clientId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<int> getTodayTotalOrders(String lineId) {
    // final now = DateTime.now();
    // final startOfDay = DateTime(now.year, now.month, now.day);
    // final endOfDay = startOfDay.add(const Duration(days: 1));

    return _ordersCollection
        .where('lineId', isEqualTo: lineId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.fold<int>(
        0,
        (sums, doc) {
          final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
          return sums + order.quantity;
        },
      );
    });
  }

  Future<void> createOrder(OrderModel order) async {
    await FirestoreService.performFirestoreOperation(() async {
      final orderId = const Uuid().v4();
      await _ordersCollection.doc(orderId).set(order.toMap());
    }, 'creating order for client: ${order.clientId}');
  }
}
