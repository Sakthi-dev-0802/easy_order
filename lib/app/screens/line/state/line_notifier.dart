import 'package:easy_order/app/firebase_services/model/line_model.dart';
import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/firebase_services/model/user_model.dart';
import 'package:easy_order/app/firebase_services/services/line_service.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class LineState {
  final bool isLoading;
  final bool isDeleting;
  final String? error;
  final LineModel? line;

  LineState({
    this.isLoading = false,
    this.isDeleting = false,
    this.error,
    this.line,
  });

  LineState copyWith({
    bool? isLoading,
    bool? isDeleting,
    String? error,
    bool? isLoggedIn,
    UserModel? user,
    List<MarketModel>? markets,
    LineModel? line,
  }) {
    return LineState(
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
      line: line ?? this.line,
    );
  }
}

class LineStateNotifier extends StateNotifier<LineState> {
  final Ref ref;

  LineStateNotifier(this.ref) : super(LineState());

  Future<void> createLine(String lineName) async {
    try {
      state = state.copyWith(isLoading: true);
      final marketId = ref.read(userMarketProvider);
      if (marketId == null) throw Exception('No market selected');

      final lineId = const Uuid().v4();
      final newLine = LineModel(
        lineId: lineId,
        lineName: lineName,
        marketId: marketId,
      );
      await LineService.instance.createLine(newLine);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateLine(String lineId, String lineName) async {
    try {
      state = state.copyWith(isLoading: true);
      final marketId = ref.read(userMarketProvider);
      if (marketId == null) throw Exception('No market selected');

      final updatedLine = LineModel(
        lineId: lineId,
        lineName: lineName,
        marketId: marketId,
      );
      await LineService.instance.updateLine(updatedLine);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteLine(String lineId) async {
    try {
      state = state.copyWith(isDeleting: true);
      await LineService.instance.deleteLine(lineId);
      state = state.copyWith(isDeleting: false);
    } catch (e) {
      state = state.copyWith(isDeleting: false, error: e.toString());
    }
  }

  Future<void> getLineById(String lineId) async {
    try {
      state = state.copyWith(isLoading: true);
      final line = await LineService.instance.getLine(lineId);
      state = state.copyWith(isLoading: false, line: line);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final lineStateProvider =
    StateNotifierProvider<LineStateNotifier, LineState>((ref) {
  return LineStateNotifier(ref);
});
