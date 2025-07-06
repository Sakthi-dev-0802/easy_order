import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/model/line_model.dart';
import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/firebase_services/model/user_model.dart';
import 'package:easy_order/app/firebase_services/services/items_service.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderStateState {
  final bool isLoading;
  final bool isCreatingOrder;
  final String? error;
  final LineModel? line;
  final List<ItemsModel>? items;
  final List<ItemsModel>? originalItems;

  OrderStateState({
    this.isLoading = false,
    this.isCreatingOrder = false,
    this.error,
    this.line,
    this.items,
    this.originalItems,
  });

  OrderStateState copyWith({
    bool? isLoading,
    bool? isCreatingOrder,
    String? error,
    bool? isLoggedIn,
    UserModel? user,
    List<MarketModel>? markets,
    LineModel? line,
    List<ItemsModel>? items,
    List<ItemsModel>? originalItems,
  }) {
    return OrderStateState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingOrder: isCreatingOrder ?? this.isCreatingOrder,
      error: error ?? this.error,
      line: line ?? this.line,
      items: items ?? this.items,
      originalItems: originalItems ?? this.originalItems,
    );
  }
}

class OrderStateStateNotifier extends StateNotifier<OrderStateState> {
  OrderStateStateNotifier() : super(OrderStateState());

  Future<void> getItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final items = await ItemsService.instance.getAllItems();
      final updatedItems =
          items.map((item) => item.copyWith(quantity: 0, noOfPack: 0)).toList();
      state = state.copyWith(
        isLoading: false,
        items: updatedItems,
        originalItems: items,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateItem(
      int index, int quantity, int noOfPack, String packType, bool isRemoved) {
    if (state.items == null || index >= state.items!.length) return;

    final updatedItems = List<ItemsModel>.from(state.items!);
    // final updatedOriginalItems = List<ItemsModel>.from(state.originalItems!);

    if (isRemoved) {
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: 0,
        noOfPack: 0,
        markedForOrder: false,
      );
    } else {
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: quantity,
        noOfPack: noOfPack,
        packingType: packType,
        markedForOrder: true,
      );
    }

    // updatedOriginalItems[index] = updatedOriginalItems[index].copyWith(
    //   quantity: quantity,
    //   noOfPack: noOfPack,
    //   packingType: packType,
    //   markedForOrder: true,
    // );

    state = state.copyWith(
      items: updatedItems,
      // originalItems: updatedOriginalItems,
    );
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      state = state.copyWith(isCreatingOrder: true);
      await OrderService.instance.createOrder(order);
      state = state.copyWith(isCreatingOrder: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreatingOrder: false);
    }
  }

  Future<ItemsModel> getDefaultOfItem(String itemId) async {
    final item = await ItemsService.instance.getDefaultOfItem(itemId);
    return item;
  }
}

final orderStateStateProvider =
    StateNotifierProvider<OrderStateStateNotifier, OrderStateState>((ref) {
  return OrderStateStateNotifier();
});
