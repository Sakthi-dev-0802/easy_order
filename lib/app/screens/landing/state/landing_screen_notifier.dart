import 'package:auto_route/auto_route.dart';
import 'package:easy_order/routes/router.dart';
import 'package:easy_order/routes/router.gr.dart'; // <- IMPORTANT
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreenState {
  final int selectedIndex;

  LandingScreenState({this.selectedIndex = 0});

  LandingScreenState copyWith({int? selectedIndex}) {
    return LandingScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class LandingScreenStateNotifier extends StateNotifier<LandingScreenState> {
  final AppRouter _router;

  LandingScreenStateNotifier(this._router) : super(LandingScreenState());

  void changePage(int index) {
    state = state.copyWith(selectedIndex: index);
    _router.replace(_getRouteForIndex(index));
  }

  PageRouteInfo _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeRoute();
      case 1:
        return const LineRoute();
      case 2:
        return const MarketInfoRoute();
      default:
        return const HomeRoute();
    }
  }
}

final landingScreenStateProvider =
    StateNotifierProvider<LandingScreenStateNotifier, LandingScreenState>(
        (ref) {
  return LandingScreenStateNotifier(AppRouter());
});
