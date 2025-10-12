import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/screens/clients/providers/orders_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityHeroCard extends ConsumerWidget {
  final String lineId;
  const QuantityHeroCard({
    super.key,
    required this.lineId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTotalOrdersAsync = ref.watch(todayTotalOrdersProvider(lineId));

    return Container(
      padding: EdgeInsets.all(spacing16),
      color: AppColor.buttonGreen.withOpacity(0.1),
      child: Row(
        spacing: spacing08,
        children: [
          const Icon(
            Icons.shopping_cart,
            color: AppColor.buttonGreen,
          ),
          Text(
            'Today\'s Total Orders:',
            style: AppTextStyle.titleMediumDark,
          ),
          todayTotalOrdersAsync.when(
            data: (total) => Text(
              '$total kg',
              style: AppTextStyle.titleMediumDark.copyWith(
                color: AppColor.buttonGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            loading: () => _buildCircularProgress(),
            error: (_, __) => _buildErrorWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() => Text(
        '0 kg',
        style: AppTextStyle.titleMediumDark.copyWith(
          color: AppColor.buttonGreen,
          fontWeight: FontWeight.bold,
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
}
