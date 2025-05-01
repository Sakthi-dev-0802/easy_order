import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Market Details'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildVendorsCard(),
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
      ),
    );
  }

  Widget _buildHeader() {
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
            'Sample Market',
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
                '123 Market Street',
                style: AppTextStyle.titleMediumDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorsCard() {
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
                    'Total Vendors',
                    style: AppTextStyle.titleMediumDark,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '25',
                    style: AppTextStyle.bodyLargeBoldDark,
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
