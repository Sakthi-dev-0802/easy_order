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

  Stream<int> getTodayTotalOrdersQuantity(String lineId, DateTime start) {
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _ordersCollection
        .where('lineId', isEqualTo: lineId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
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

  Stream<int> getClientTotalOrders(String clientId, DateTime start) {
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _ordersCollection
        .where('clientId', isEqualTo: clientId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
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

  Future<List<OrderModel>> getTodayOrderForClient(
    String clientId,
    DateTime start,
  ) async {
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final querySnapshot = await _ordersCollection
        .where('clientId', isEqualTo: clientId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> createOrder(OrderModel order) async {
    await FirestoreService.performFirestoreOperation(() async {
      // Find today's order for the client
      final startOfDay = DateTime(
          order.orderDate.year, order.orderDate.month, order.orderDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final querySnapshot = await _ordersCollection
          .where('clientId', isEqualTo: order.clientId)
          .where('orderDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first found order for today
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update(order.toMap());
      } else {
        // Create new order
        final orderId = const Uuid().v4();
        await _ordersCollection.doc(orderId).set(order.toMap());
      }
    }, 'creating/updating order for client: ${order.clientId}');
  }
}
