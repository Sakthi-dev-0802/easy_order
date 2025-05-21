import 'package:easy_order/app/firebase_services/model/line_model.dart';
import 'package:easy_order/app/firebase_services/services/line_service.dart';
import 'package:easy_order/core/utils/user_market_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allLinesProvider = StreamProvider<List<LineModel>>((ref) {
  final marketId = UserMarketService.userMarket;
  if (marketId == null) return Stream.value([]);

  return LineService.instance.getLinesByMarketId(marketId);
});
