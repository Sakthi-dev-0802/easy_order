import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/services/items_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemState {
  final bool isLoading;
  final String? error;

  ItemState({
    this.isLoading = false,
    this.error,
  });

  ItemState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ItemStateNotifier extends StateNotifier<ItemState> {
  ItemStateNotifier() : super(ItemState());

  Future<void> createItem(ItemsModel item) async {
    state = state.copyWith(isLoading: true);
    try {
      await ItemsService.instance.createItem(item);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final itemStateProvider =
    StateNotifierProvider<ItemStateNotifier, ItemState>((ref) {
  return ItemStateNotifier();
});
