import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/screens/home/home_screen.dart';
import 'package:easy_order/app/screens/line/line_screen.dart';
import 'package:easy_order/app/screens/market_info/market_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/landing_screen_notifier.dart';

@RoutePage()
class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(landingScreenStateProvider);
    final notifier = ref.read(landingScreenStateProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (selectedIndex.selectedIndex == 0) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          notifier.changePage(0);
        }
      },
      child: const Scaffold(
        // appBar: AppBar(
        //   actionsPadding: const EdgeInsets.only(right: 12),
        //   backgroundColor: Colors.white,
        //   title: const Text("Market 1"),
        //   actions: [
        //     ButtonComponent.filled(
        //       label: "order",
        //       onTap: () {},
        //     )
        //   ],
        // ),
        body: _BodyWidget(),
        bottomNavigationBar: _BottomNavWidget(),
      ),
    );
  }
}

class _BodyWidget extends ConsumerWidget {
  const _BodyWidget();

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const LinePage();
      case 2:
        return const MarketInfoPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(landingScreenStateProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: _buildScreen(index.selectedIndex),
    );
  }
}

class _BottomNavWidget extends ConsumerWidget {
  const _BottomNavWidget();

  static const double _iconSize = 24;

  BottomNavigationBarItem _buildNavItem({
    required Widget icon,
    required Widget activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      activeIcon: activeIcon,
      label: label,
      tooltip: '',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(landingScreenStateProvider);
    final notifier = ref.read(landingScreenStateProvider.notifier);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex.selectedIndex,
        onTap: notifier.changePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black87,
        selectedFontSize: 12,
        items: [
          _buildNavItem(
            icon: const Icon(
              Icons.home_outlined,
              size: _iconSize,
            ),
            activeIcon: const Icon(Icons.home, size: _iconSize),
            label: 'Home',
          ),
          _buildNavItem(
            icon: const Icon(Icons.subject_outlined, size: _iconSize),
            activeIcon: const Icon(Icons.subject, size: _iconSize),
            label: 'Line',
          ),
          _buildNavItem(
            icon: const Icon(Icons.storefront_outlined, size: _iconSize),
            activeIcon: const Icon(Icons.storefront, size: _iconSize),
            label: 'Market',
          ),
        ],
      ),
    );
  }
}
