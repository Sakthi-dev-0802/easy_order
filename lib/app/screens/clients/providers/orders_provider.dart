import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/firebase_services/services/client_service.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:easy_order/core/utils/user_market_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO: Need to change to Future instead of Stream
final clientOrdersProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, clientId) {
  return OrderService.instance.getTodayOrdersByClientId(clientId);
});

final todayTotalOrdersProvider = StreamProvider<int>((ref) {
  return OrderService.instance.getTodayTotalOrders();
});

final clientsByLineProvider =
    StreamProvider.family<List<ClientModel>, String>((ref, lineId) {
  final marketId = UserMarketService.userMarket;
  if (marketId == null) return Stream.value([]);
  return ClientService.instance.getClients(marketId, lineId: lineId);
});
