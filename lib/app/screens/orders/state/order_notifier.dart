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
  final bool isFetchingDefault;
  final String? error;
  final LineModel? line;
  final List<ItemsModel>? items;

  OrderStateState({
    this.isLoading = false,
    this.isCreatingOrder = false,
    this.isFetchingDefault = false,
    this.error,
    this.line,
    this.items,
  });

  OrderStateState copyWith({
    bool? isLoading,
    bool? isCreatingOrder,
    bool? isFetchingDefault,
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
      isFetchingDefault: isFetchingDefault ?? this.isFetchingDefault,
      error: error ?? this.error,
      line: line ?? this.line,
      items: items ?? this.items,
    );
  }
}

class OrderStateStateNotifier extends StateNotifier<OrderStateState> {
  OrderStateStateNotifier() : super(OrderStateState());

  Future<void> getItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final items = await ItemsService.instance.getAllItems();
      final resetItems = items
          .map((item) => item.copyWith(
                quantity: 0,
                noOfPack: 0,
                markedForOrder: false,
              ))
          .toList();
      state = state.copyWith(
        isLoading: false,
        items: resetItems,
        originalItems: resetItems,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateItem(
      int index, int quantity, int noOfPack, String packType, bool isRemoved) {
    if (state.items == null || index >= state.items!.length) return;

    final updatedItems = List<ItemsModel>.from(state.items!);

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

    state = state.copyWith(items: updatedItems);
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

  Future<void> getClientOrders(String clientId, DateTime start) async {
    try {
      state = state.copyWith(isLoading: true);

      final orders =
          await OrderService.instance.getTodayOrderForClient(clientId, start);

      final orderedItems = orders
          .expand((order) => order.items)
          .where((item) => item.markedForOrder == true)
          .toList();

      final orderedItemIds = orderedItems.map((item) => item.uid).toList();
      final currentItems = List<ItemsModel>.from(state.items ?? []);

      final updatedItems = currentItems.map((item) {
        if (orderedItemIds.contains(item.uid)) {
          final orderedItem =
              orderedItems.firstWhere((ordered) => ordered.uid == item.uid);
          return item.copyWith(
            quantity: orderedItem.quantity,
            packingType: orderedItem.packType,
            noOfPack: orderedItem.noOfPack,
            markedForOrder: true,
          );
        } else {
          return item.copyWith(
            quantity: 0,
            noOfPack: 0,
            markedForOrder: false,
          );
        }
      }).toList();

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<ItemsModel?> getDefaultOfItem(String itemId) async {
    try {
      state = state.copyWith(isFetchingDefault: true);
      final item = await ItemsService.instance.getDefaultOfItem(itemId);
      state = state.copyWith(isFetchingDefault: false);

      return item;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isFetchingDefault: false);
      return null;
    }
  }
}

final orderStateStateProvider =
    StateNotifierProvider<OrderStateStateNotifier, OrderStateState>((ref) {
  return OrderStateStateNotifier();
});
