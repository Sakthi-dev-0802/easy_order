import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/services/client_service.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayTotalOrdersProvider =
    StreamProvider.family<int, ({String lineId, DateTime start})>((ref, args) {
  return OrderService.instance
      .getTodayTotalOrdersQuantityByLine(args.lineId, args.start);
});

final todayTotalOrderByClientProvider =
    StreamProvider.family<int, ({String clientId, DateTime start})>(
        (ref, args) {
  return OrderService.instance.getClientTotalOrders(args.clientId, args.start);
});

final clientsByLineProvider =
    StreamProvider.family<List<ClientModel>, String>((ref, lineId) {
  final marketId = ref.watch(userMarketProvider);
  if (marketId == null) return Stream.value([]);
  return ClientService.instance.getClients(marketId, lineId: lineId);
});
