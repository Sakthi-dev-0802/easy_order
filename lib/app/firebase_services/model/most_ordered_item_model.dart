import 'package:easy_order/app/firebase_services/model/items_model.dart';

class MostOrderedItemModel {
  final ItemsModel item;
  final int totalQuantity;
  final int bagCount;
  final int smallBoxCount;
  final int bigBoxCount;

  MostOrderedItemModel({
    required this.item,
    required this.totalQuantity,
    required this.bagCount,
    required this.smallBoxCount,
    required this.bigBoxCount,
  });
}
