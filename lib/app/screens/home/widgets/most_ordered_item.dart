import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class MostOrderedItem extends StatelessWidget {
  final List<ItemsModel> items;
  const MostOrderedItem({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2196F3),
                Color(0xFF298F05),
              ],
            ),
            borderRadius: BorderRadius.circular(radius08),
            border: Border.all(color: AppColor.borderMutedGray),
          ),
          child: Row(
            children: [
              Text(
                item.itemName,
                style: AppTextStyle.bodyTextSmallLightWhite,
              ),
              const Spacer(),
              Text(
                item.quantity.toString(),
                style: AppTextStyle.titleLargeLightWhite,
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
      itemCount: items.length,
    );
  }
}
