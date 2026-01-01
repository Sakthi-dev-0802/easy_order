import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/model/most_ordered_item_model.dart';
import 'package:easy_order/app/firebase_services/model/total_pack_counts_model.dart';
import 'package:easy_order/app/firebase_services/services/items_service.dart';
import 'package:uuid/uuid.dart';

import '../base_service.dart';
import '../model/order_model.dart';

class OrderService with FirestoreService {
  OrderService._();
  static final OrderService instance = OrderService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _ordersCollection =
      _firestore.collection('orders');

  Stream<int> getTodayTotalOrdersQuantityByLine(String lineId, DateTime start) {
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

  Stream<int> getTodayTotalOrdersQuantityByMarket(
    String marketId,
    DateTime start,
  ) {
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _ordersCollection
        .where('marketId', isEqualTo: marketId)
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

        // Get existing order to preserve loaded status
        final existingOrder = OrderModel.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);

        // Create a map of existing items by uid to preserve loaded status
        final existingItemsMap = <String, ItemsModel>{};
        for (final item in existingOrder.items) {
          existingItemsMap[item.uid] = item;
        }

        // Merge new items with existing loaded status
        final mergedItems = order.items.map((newItem) {
          final existingItem = existingItemsMap[newItem.uid];
          if (existingItem != null && existingItem.loaded) {
            // Preserve loaded status from existing item
            return newItem.copyWith(loaded: true);
          }
          return newItem;
        }).toList();

        // Create updated order with merged items
        final updatedOrder = OrderModel(
          uid: existingOrder.uid,
          clientId: order.clientId,
          lineId: order.lineId,
          marketId: order.marketId,
          quantity: order.quantity,
          orderDate: order.orderDate,
          items: mergedItems,
        );

        await docRef.update(updatedOrder.toMap());
      } else {
        // Create new order
        final orderId = const Uuid().v4();
        await _ordersCollection.doc(orderId).set(order.toMap());
      }
    }, 'creating/updating order for client: ${order.clientId}');
  }

  Stream<List<ItemsModel>> mostOrderedItemsStream({
    required String marketId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final Query ordersQuery = _ordersCollection
        .where('marketId', isEqualTo: marketId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay));

    return ordersQuery.snapshots().asyncMap((snapshot) async {
      // Get canonical items (so items with 0 orders are included)
      final items = await ItemsService.instance.getAllItems();

      // Aggregate quantities by item uid
      final Map<String, int> totals = {};

      for (final doc in snapshot.docs) {
        final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        for (final orderedItem in order.items) {
          final qty = orderedItem.quantity ?? 0;
          totals.update(orderedItem.uid, (v) => v + qty, ifAbsent: () => qty);
        }
      }

      // Map totals onto items list, defaulting to 0 if not present
      final List<ItemsModel> result = items
          .map((it) => it.copyWith(quantity: totals[it.uid] ?? 0))
          .toList();

      // Sort ascending by aggregated quantity
      result.sort((a, b) {
        final aq = a.quantity ?? 0;
        final bq = b.quantity ?? 0;
        return bq.compareTo(aq);
      });

      return result;
    });
  }

  Stream<List<MostOrderedItemModel>> mostOrderedItemsWithPackCountsStream({
    required String marketId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final Query ordersQuery = _ordersCollection
        .where('marketId', isEqualTo: marketId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay));

    return ordersQuery.snapshots().asyncMap((snapshot) async {
      // Get canonical items (so items with 0 orders are included)
      final items = await ItemsService.instance.getAllItems();

      // Aggregate quantities, bag counts, and box counts by item uid
      final Map<String, int> totals = {};
      final Map<String, int> bagTotals = {};
      final Map<String, int> smallBoxTotals = {};
      final Map<String, int> bigBoxTotals = {};

      for (final doc in snapshot.docs) {
        final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        for (final orderedItem in order.items) {
          final qty = orderedItem.quantity ?? 0;
          final packType = orderedItem.packType ?? '';
          final noOfPack = orderedItem.noOfPack ?? 0;

          // Aggregate total quantity
          totals.update(orderedItem.uid, (v) => v + qty, ifAbsent: () => qty);

          // Aggregate bag counts
          if (packType == 'BAG') {
            bagTotals.update(orderedItem.uid, (v) => v + noOfPack,
                ifAbsent: () => noOfPack);
          }

          // Aggregate small box counts
          if (packType == 'SMALL BOX' || packType == 'BOX') {
            smallBoxTotals.update(orderedItem.uid, (v) => v + noOfPack,
                ifAbsent: () => noOfPack);
          }

          // Aggregate big box counts
          if (packType == 'BIG BOX') {
            bigBoxTotals.update(orderedItem.uid, (v) => v + noOfPack,
                ifAbsent: () => noOfPack);
          }
        }
      }

      // Map totals onto items list
      final List<MostOrderedItemModel> result = items
          .map((it) => MostOrderedItemModel(
                item: it.copyWith(quantity: totals[it.uid] ?? 0),
                totalQuantity: totals[it.uid] ?? 0,
                bagCount: bagTotals[it.uid] ?? 0,
                smallBoxCount: smallBoxTotals[it.uid] ?? 0,
                bigBoxCount: bigBoxTotals[it.uid] ?? 0,
              ))
          .toList();

      // Sort by total quantity (descending)
      result.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));

      return result;
    });
  }

  Stream<TotalPackCountsModel> getTotalPackCountsStream({
    required String marketId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final Query ordersQuery = _ordersCollection
        .where('marketId', isEqualTo: marketId)
        .where('orderDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay));

    return ordersQuery.snapshots().map((snapshot) {
      int totalSmallBox = 0;
      int totalBigBox = 0;
      int totalBag = 0;

      for (final doc in snapshot.docs) {
        final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        for (final orderedItem in order.items) {
          final packType = orderedItem.packType ?? '';
          final noOfPack = orderedItem.noOfPack ?? 0;

          if (packType == 'SMALL BOX' || packType == 'BOX') {
            totalSmallBox += noOfPack;
          } else if (packType == 'BIG BOX') {
            totalBigBox += noOfPack;
          } else if (packType == 'BAG') {
            totalBag += noOfPack;
          }
        }
      }

      return TotalPackCountsModel(
        smallBoxCount: totalSmallBox,
        bigBoxCount: totalBigBox,
        bagCount: totalBag,
      );
    });
  }

  Future<List<OrderModel>> getTodaysOrdersByLine(
    String lineId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final querySnapshot = await _ordersCollection
        .where('lineId', isEqualTo: lineId)
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

  /// Update the loaded status of a specific item in an order
  Future<void> updateItemLoadedStatus({
    required String clientId,
    required String itemId,
    required bool loaded,
    required DateTime orderDate,
  }) async {
    await FirestoreService.performFirestoreOperation(() async {
      final startOfDay =
          DateTime(orderDate.year, orderDate.month, orderDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Find today's order for the client
      final querySnapshot = await _ordersCollection
          .where('clientId', isEqualTo: clientId)
          .where('orderDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('orderDate', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Order not found for client: $clientId');
      }

      final doc = querySnapshot.docs.first;
      final orderData = doc.data() as Map<String, dynamic>;
      final order = OrderModel.fromMap(orderData);

      // Update the specific item's loaded status
      final updatedItems = order.items.map((item) {
        if (item.uid == itemId) {
          return item.copyWith(loaded: loaded);
        }
        return item;
      }).toList();

      // Create updated order
      final updatedOrder = OrderModel(
        uid: order.uid,
        clientId: order.clientId,
        lineId: order.lineId,
        marketId: order.marketId,
        quantity: order.quantity,
        orderDate: order.orderDate,
        items: updatedItems,
      );

      // Update in Firestore
      await doc.reference.update(updatedOrder.toMap());
    }, 'updating loaded status for item: $itemId in client: $clientId');
  }
}
