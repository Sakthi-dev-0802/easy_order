import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/services/client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientState {
  final bool isLoading;
  final String? error;

  ClientState({
    this.isLoading = false,
    this.error,
  });

  ClientState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ClientState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ClientStateNotifier extends StateNotifier<ClientState> {
  ClientStateNotifier() : super(ClientState());

  Future<void> createClient(ClientModel client) async {
    state = state.copyWith(isLoading: true);
    try {
      await ClientService.instance.createClient(client);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final clientStateProvider =
    StateNotifierProvider<ClientStateNotifier, ClientState>((ref) {
  return ClientStateNotifier();
});
