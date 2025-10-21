import 'package:easy_order/app/components/progress_bar.dart';
import 'package:easy_order/app/providers/date_selection_provider.dart';
import 'package:easy_order/app/screens/home/provider/total_quantity_provider.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailContainer extends ConsumerWidget {
  const OrderDetailContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalDate = ref.watch(dateSelectionProvider);
    final marketId = ref.watch(userMarketProvider);
    const double borderWidth = 2.0;
    final BorderRadius borderRadius = BorderRadius.circular(8.0);
    final totalOrdersQuantityAsyncValue = ref.watch(
      totalQuantityProvider((marketId: marketId ?? '', start: globalDate)),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2196F3), // Material Blue
            Color(0xFF298F05),
          ],
        ),
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(borderWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius.subtract(
              BorderRadius.circular(borderWidth),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: borderRadius,
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    totalOrdersQuantityAsyncValue.when(
                      data: (data) => Text(
                        data.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      loading: () => const ProgressBarWidget(size: 24),
                      error: (error, stack) => const Text(
                        '0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
