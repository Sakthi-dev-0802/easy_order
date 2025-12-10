import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/app/firebase_services/services/market_service.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
import 'package:easy_order/core/storage/app_storage.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final BuildContext currentContext = context;

    final user = await AppStorage.getUser;

    if (!currentContext.mounted) return;

    if (user == null) {
      currentContext.router.replaceAll([AppRoutes.loginPage]);
    } else {
      // Validate market ID exists in database
      if (user.marketId.isEmpty) {
        // Clear invalid user data and redirect to login
        await AppStorage.clearUser();
        if (currentContext.mounted) {
          currentContext.router.replaceAll([AppRoutes.loginPage]);
        }
        return;
      }

      try {
        final market = await MarketService.getMarketById(user.marketId);
        
        if (market == null) {
          // Market ID not found in database - clear user and redirect to login
          await AppStorage.clearUser();
          if (currentContext.mounted) {
            currentContext.router.replaceAll([AppRoutes.loginPage]);
          }
          return;
        }

        // Market exists, proceed with navigation
        ref.read(loginStateProvider.notifier).setUser(user);
        ref.read(userMarketProvider.notifier).state = user.marketId;
        if (currentContext.mounted) {
          currentContext.router.replaceAll([AppRoutes.landing]);
        }
      } catch (e) {
        // Error checking market - clear user and redirect to login
        await AppStorage.clearUser();
        if (currentContext.mounted) {
          currentContext.router.replaceAll([AppRoutes.loginPage]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColor.buttonGreen,
          strokeWidth: size02,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
