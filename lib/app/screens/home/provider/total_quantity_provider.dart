import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalQuantityProvider =
    StreamProvider.family<int, ({String marketId, DateTime start})>(
        (ref, args) {
  return OrderService.instance
      .getTodayTotalOrdersQuantityByMarket(args.marketId, args.start);
});
