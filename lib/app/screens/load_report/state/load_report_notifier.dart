import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/firebase_services/services/items_service.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:easy_order/app/screens/clients/providers/orders_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadreportState {
  final bool isLoading;
  final String? error;
  final List<ItemsModel>? items;
  final List<ClientModel>? clients;
  final List<OrderModel>? orders;
  final Set<String> loadedCells; // Key format: "itemId_clientId"
  final DateTime? orderDate; // Store the date for API calls

  LoadreportState({
    this.isLoading = false,
    this.error,
    this.items,
    this.clients,
    this.orders,
    Set<String>? loadedCells,
    this.orderDate,
  }) : loadedCells = loadedCells ?? {};

  LoadreportState copyWith({
    bool? isLoading,
    String? error,
    final List<ItemsModel>? items,
    final List<ClientModel>? clients,
    final List<OrderModel>? orders,
    Set<String>? loadedCells,
    DateTime? orderDate,
  }) {
    return LoadreportState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        items: items ?? this.items,
        clients: clients ?? this.clients,
        orders: orders ?? this.orders,
        loadedCells: loadedCells ?? this.loadedCells,
        orderDate: orderDate ?? this.orderDate);
  }
}

class LoadreportStateNotifier extends StateNotifier<LoadreportState> {
  final Ref ref;
  LoadreportStateNotifier(this.ref) : super(LoadreportState());

  /// Loads Items + Clients + Today's Orders together.
  Future<void> getReportData(String lineId, DateTime date) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final results = await Future.wait([
        ItemsService.instance.getAllItems(),
        ref.read(clientsByLineProvider(lineId).future),
        OrderService.instance.getTodaysOrdersByLine(lineId, date),
      ]);

      final orders = results[2] as List<OrderModel>;

      // Initialize loadedCells from orders (items with loaded=true)
      final loadedCells = <String>{};
      for (final order in orders) {
        for (final item in order.items) {
          if (item.loaded) {
            loadedCells.add('${item.uid}_${order.clientId}');
          }
        }
      }

      state = state.copyWith(
        isLoading: false,
        items: results[0] as List<ItemsModel>,
        clients: results[1] as List<ClientModel>,
        orders: orders,
        loadedCells: loadedCells,
        orderDate: date,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Check if a date is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Toggle loaded status for a specific cell (item + client combination)
  /// Updates both local state and backend via API
  /// Only works for current date
  Future<void> toggleLoadedStatus(String itemId, String clientId) async {
    if (state.orderDate == null) {
      throw Exception('Order date not set. Cannot update loaded status.');
    }

    if (!_isToday(state.orderDate!)) {
      throw Exception('Loading status can only be updated for today\'s date.');
    }

    final cellKey = '${itemId}_$clientId';
    final isCurrentlyLoaded = state.loadedCells.contains(cellKey);
    final newLoadedStatus = !isCurrentlyLoaded;

    // Optimistically update UI
    final updatedLoadedCells = Set<String>.from(state.loadedCells);
    if (newLoadedStatus) {
      updatedLoadedCells.add(cellKey);
    } else {
      updatedLoadedCells.remove(cellKey);
    }
    state = state.copyWith(loadedCells: updatedLoadedCells);

    try {
      // Update backend
      await OrderService.instance.updateItemLoadedStatus(
        clientId: clientId,
        itemId: itemId,
        loaded: newLoadedStatus,
        orderDate: state.orderDate!,
      );

      // Update local orders state to reflect the change
      final updatedOrders = state.orders?.map((order) {
        if (order.clientId == clientId) {
          final updatedItems = order.items.map((item) {
            if (item.uid == itemId) {
              return item.copyWith(loaded: newLoadedStatus);
            }
            return item;
          }).toList();
          return OrderModel(
            uid: order.uid,
            clientId: order.clientId,
            lineId: order.lineId,
            marketId: order.marketId,
            quantity: order.quantity,
            orderDate: order.orderDate,
            items: updatedItems,
          );
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      // Revert optimistic update on error
      final revertedLoadedCells = Set<String>.from(state.loadedCells);
      if (newLoadedStatus) {
        revertedLoadedCells.remove(cellKey);
      } else {
        revertedLoadedCells.add(cellKey);
      }
      state = state.copyWith(
        loadedCells: revertedLoadedCells,
        error: 'Failed to update loaded status: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Check if a specific cell is loaded
  bool isCellLoaded(String itemId, String clientId) {
    final cellKey = '${itemId}_$clientId';
    return state.loadedCells.contains(cellKey);
  }

  /// Update an order item (quantity, packType, noOfPack)
  /// Only works for current date
  Future<void> updateOrderItem({
    required String itemId,
    required String clientId,
    required int quantity,
    required String packType,
    required int noOfPack,
    bool isRemoved = false,
  }) async {
    if (state.orderDate == null) {
      throw Exception('Order date not set. Cannot update order item.');
    }

    if (!_isToday(state.orderDate!)) {
      throw Exception('Order items can only be updated for today\'s date.');
    }

    try {
      // Find the client's order
      final clientOrder = state.orders
          ?.where(
            (o) => o.clientId == clientId,
          )
          .firstOrNull;

      if (clientOrder == null) {
        throw Exception('Order not found for client: $clientId');
      }

      // Update the item in the order
      final updatedItems = clientOrder.items.map((item) {
        if (item.uid == itemId) {
          if (isRemoved) {
            // Remove item by setting quantity to 0
            return item.copyWith(
              quantity: 0,
              noOfPack: 0,
              markedForOrder: false,
            );
          } else {
            // Update item with new values, preserve loaded status
            return item.copyWith(
              quantity: quantity,
              packingType: packType,
              noOfPack: noOfPack,
              markedForOrder: true,
              loaded: item.loaded, // Preserve loaded status
            );
          }
        }
        return item;
      }).toList();

      // Remove items with quantity 0
      final filteredItems = updatedItems
          .where((item) => item.quantity != null && item.quantity! > 0)
          .toList();

      // Calculate new total quantity
      final totalQuantity = filteredItems
          .map((item) => item.quantity ?? 0)
          .fold(0, (sum, qty) => sum + qty);

      // Create updated order
      final updatedOrder = OrderModel(
        uid: clientOrder.uid,
        clientId: clientOrder.clientId,
        lineId: clientOrder.lineId,
        marketId: clientOrder.marketId,
        quantity: totalQuantity,
        orderDate: clientOrder.orderDate,
        items: filteredItems,
      );

      // Update in backend
      await OrderService.instance.createOrder(updatedOrder);

      // Update local state
      final updatedOrders = state.orders?.map((order) {
        if (order.clientId == clientId) {
          return updatedOrder;
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final loadReportStatePRovider =
    StateNotifierProvider<LoadreportStateNotifier, LoadreportState>((ref) {
  return LoadreportStateNotifier(ref);
});
