import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class MostOrderedItem extends StatelessWidget {
  const MostOrderedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2196F3), // Material Blue
                    Color(0xFF298F05),
                  ],
                ),
                borderRadius: BorderRadius.circular(radius08),
                border: Border.all(color: AppColor.borderMutedGray),
              ),
              child: Row(
                children: [
                  Text(
                    "Tomato",
                    style: AppTextStyle.bodyTextSmallLightWhite,
                  ),
                  const Spacer(),
                  Text(
                    "25kg",
                    style: AppTextStyle.titleLargeLightWhite,
                  )
                ],
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: 10);
  }
}
