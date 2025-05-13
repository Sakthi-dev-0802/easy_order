import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/screens/clients/providers/orders_provider.dart';
import 'package:easy_order/app/screens/market_info/providers/market_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ClientsListPage extends ConsumerWidget {
  const ClientsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final todayTotalOrdersAsync = ref.watch(todayTotalOrdersProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: Text(
          'Clients List',
          style: AppTextStyle.titleLargeLightWhite.copyWith(
            color: AppColor.textBlack,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.router.push(AppRoutes.addLinePage);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.router.push(AppRoutes.addClientPage);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColor.buttonGreen.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: AppColor.buttonGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Total Orders:',
                  style: AppTextStyle.titleMediumDark,
                ),
                const SizedBox(width: 8),
                todayTotalOrdersAsync.when(
                  data: (total) => Text(
                    '$total kg',
                    style: AppTextStyle.titleMediumDark.copyWith(
                      color: AppColor.buttonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.buttonGreen,
                    ),
                  ),
                  error: (_, __) => Text(
                    '0 kg',
                    style: AppTextStyle.titleMediumDark.copyWith(
                      color: AppColor.buttonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: clientsAsync.when(
              data: (clients) {
                if (clients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColor.textDarkGray.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No clients found',
                          style: AppTextStyle.titleMediumDark,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return _ClientCard(client: client);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColor.buttonGreen,
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColor.textDarkGray.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading clients',
                      style: AppTextStyle.titleMediumDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends ConsumerWidget {
  final ClientModel client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(clientOrdersProvider(client.uid));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: AppColor.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius08),
        side: const BorderSide(
          color: AppColor.borderMutedGray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.buttonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(radius08),
              ),
              child: const Icon(
                Icons.store,
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
                    client.name,
                    style: AppTextStyle.titleLargeLightWhite.copyWith(
                      color: AppColor.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    client.phone,
                    style: AppTextStyle.bodyLargeBoldDark,
                  ),
                  Text(
                    client.address,
                    style: AppTextStyle.bodyLargeBoldDark,
                  ),
                ],
              ),
            ),
            ordersAsync.when(
              data: (orders) {
                final totalQuantity = orders.fold<int>(
                  0,
                  (sum, order) => sum + order.quantity,
                );
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.buttonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(radius08),
                  ),
                  child: Text(
                    '$totalQuantity kg',
                    style: AppTextStyle.bodyLargeBoldDark.copyWith(
                      color: AppColor.buttonGreen,
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.buttonGreen,
                ),
              ),
              error: (_, __) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.buttonGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(radius08),
                ),
                child: Text(
                  '0 kg',
                  style: AppTextStyle.bodyLargeBoldDark.copyWith(
                    color: AppColor.buttonGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
