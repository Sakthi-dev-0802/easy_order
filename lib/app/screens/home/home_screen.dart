import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
import 'package:easy_order/core/utils/user_market_service.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Current market ---> ${UserMarketService.userMarket}');
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () async {
              await ref.read(loginStateProvider.notifier).signOut();
              if (context.mounted) {
                context.router.replace(AppRoutes.loginPage);
              }
            },
            child: const Text('Log Out'),
          )
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
