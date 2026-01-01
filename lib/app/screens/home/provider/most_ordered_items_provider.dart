import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/model/most_ordered_item_model.dart';
import 'package:easy_order/app/firebase_services/model/total_pack_counts_model.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mostOrderedItemsProvider = StreamProvider.family<
    List<ItemsModel>,
    ({
      String marketId,
      DateTime date,
    })>((ref, args) {
  return OrderService.instance
      .mostOrderedItemsStream(marketId: args.marketId, date: args.date);
});

final mostOrderedItemsWithPackCountsProvider = StreamProvider.family<
    List<MostOrderedItemModel>,
    ({
      String marketId,
      DateTime date,
    })>((ref, args) {
  return OrderService.instance.mostOrderedItemsWithPackCountsStream(
      marketId: args.marketId, date: args.date);
});

final totalPackCountsProvider = StreamProvider.family<
    TotalPackCountsModel,
    ({
      String marketId,
      DateTime date,
    })>((ref, args) {
  return OrderService.instance
      .getTotalPackCountsStream(marketId: args.marketId, date: args.date);
});
