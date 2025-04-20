import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/firebase_services/services/market_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketsProvider =
    AsyncNotifierProvider<MarketsNotifier, List<MarketModel>>(() {
  return MarketsNotifier();
});

class MarketsNotifier extends AsyncNotifier<List<MarketModel>> {
  @override
  Future<List<MarketModel>> build() async {
    return MarketService.getAllMarkets();
  }
}
