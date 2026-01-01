import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ItemsCard extends StatelessWidget {
  const ItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.navigate(AppRoutes.itemsListPage),
      child: Container(
        padding: EdgeInsets.all(spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius12),
          border: Border.all(
            color: AppColor.buttonGreen.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.buttonGreen.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing12),
              decoration: BoxDecoration(
                color: AppColor.buttonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(radius08),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColor.buttonGreen,
                size: 32,
              ),
            ),
            SizedBox(width: spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items',
                    style: AppTextStyle.titleLargeDark.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing04),
                  Text(
                    'View all items',
                    style: AppTextStyle.bodyLargeBoldDark.copyWith(
                      fontSize: 12,
                      color: AppColor.textDarkGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.buttonGreen,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
