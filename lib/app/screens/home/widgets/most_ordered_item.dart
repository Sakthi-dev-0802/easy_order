import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/most_ordered_item_model.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class MostOrderedItem extends StatelessWidget {
  final List<MostOrderedItemModel> items;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.item.itemName,
                      style: AppTextStyle.bodyTextSmallLightWhite.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${item.totalQuantity}kg',
                    style: AppTextStyle.titleLargeLightWhite,
                  ),
                ],
              ),
              SizedBox(height: spacing08),
              Row(
                children: [
                  if (item.smallBoxCount > 0) ...[
                    _buildPackInfo('SMALL BOX', item.smallBoxCount),
                    if (item.bigBoxCount > 0 || item.bagCount > 0)
                      SizedBox(width: spacing16),
                  ],
                  if (item.bigBoxCount > 0) ...[
                    _buildPackInfo('BIG BOX', item.bigBoxCount),
                    if (item.bagCount > 0) SizedBox(width: spacing16),
                  ],
                  if (item.bagCount > 0) _buildPackInfo('BAG', item.bagCount),
                ],
              ),
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

  Widget _buildPackInfo(String label, int count) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppTextStyle.bodyTextSmallLightWhite.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            count.toString(),
            style: AppTextStyle.bodyTextSmallLightWhite.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
