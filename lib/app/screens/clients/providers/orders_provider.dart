import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientOrdersProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, clientId) {
  return OrderService.instance.getTodayOrdersByClientId(clientId);
});

final todayTotalOrdersProvider = StreamProvider<int>((ref) {
  return OrderService.instance.getTodayTotalOrders();
});
