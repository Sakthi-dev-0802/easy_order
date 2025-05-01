import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/firebase_services/services/client_service.dart';
import 'package:easy_order/app/firebase_services/services/market_service.dart';
import 'package:easy_order/core/utils/user_market_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketInfoProvider = FutureProvider<MarketModel?>((ref) async {
  final marketId = UserMarketService.userMarket;
  if (marketId == null) return null;
  return MarketService.getMarketById(marketId);
});

final clientsProvider = StreamProvider<List<ClientModel>>((ref) {
  final marketId = UserMarketService.userMarket;
  if (marketId == null) return Stream.value([]);

  return ClientService.instance.getClientsByMarketId(marketId);
});
