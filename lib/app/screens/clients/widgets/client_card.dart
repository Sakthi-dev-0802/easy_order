import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/screens/clients/providers/orders_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientCard extends ConsumerWidget {
  final ClientModel client;

  const ClientCard({super.key, required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(clientOrdersProvider(client.uid));

    return Card(
      margin: EdgeInsets.only(bottom: spacing16),
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
        padding: EdgeInsets.all(spacing16),
        child: Row(
          children: [
            _buildStoreIcon(),
            SizedBox(width: spacing16),
            _buildClientDetail(),
            ordersAsync.when(
              data: (orders) {
                final totalQuantity = orders.fold<int>(
                  0,
                  (sum, order) => sum + order.quantity,
                );

                return _buildQuantity(totalQuantity);
              },
              loading: () => _buildCircularProgress(),
              error: (_, __) => _buildErrorWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() => Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing06,
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
      );

  Widget _buildCircularProgress() => SizedBox(
        width: size20,
        height: size20,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.buttonGreen,
        ),
      );

  Widget _buildQuantity(int totalQuantity) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing06,
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

  Widget _buildClientDetail() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.name,
              style: AppTextStyle.titleLargeLightWhite.copyWith(
                color: AppColor.textBlack,
              ),
            ),
            SizedBox(height: spacing04),
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
      );

  Widget _buildStoreIcon() => Container(
        padding: EdgeInsets.all(spacing12),
        decoration: BoxDecoration(
          color: AppColor.buttonGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius08),
        ),
        child: Icon(
          Icons.store,
          color: AppColor.buttonGreen,
          size: size24,
        ),
      );
}
