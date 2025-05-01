import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
import 'package:easy_order/app/screens/market_info/providers/market_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class MarketInfoPage extends ConsumerWidget {
  const MarketInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketAsync = ref.watch(marketInfoProvider);
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Market Details'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: marketAsync.when(
        data: (market) {
          if (market == null) {
            return const Center(
              child: Text('No market information available'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(market),
                const SizedBox(height: 24),
                _buildClientsCard(clientsAsync),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref.read(loginStateProvider.notifier).signOut();
                        if (context.mounted) {
                          context.router.replace(AppRoutes.loginPage);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonGreen,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius08),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: AppTextStyle.titleLargeLightWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColor.buttonGreen,
            strokeWidth: 2,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildHeader(MarketModel market) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            market.name,
            style: AppTextStyle.headingLargeBlack,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColor.buttonGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                market.location,
                style: AppTextStyle.titleMediumDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientsCard(AsyncValue<List<ClientModel>> clientsAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius08),
          border: Border.all(color: AppColor.borderMutedGray),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.buttonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(radius08),
              ),
              child: const Icon(
                Icons.people,
                color: AppColor.buttonGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Clients',
                    style: AppTextStyle.titleMediumDark,
                  ),
                  const SizedBox(height: 4),
                  clientsAsync.when(
                    data: (clients) => Text(
                      clients.length.toString(),
                      style: AppTextStyle.bodyLargeBoldDark,
                    ),
                    loading: () => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.buttonGreen,
                      ),
                    ),
                    error: (error, _) => Text(
                      'Error',
                      style: AppTextStyle.bodyLargeBoldDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
