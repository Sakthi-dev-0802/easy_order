import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/total_pack_counts_model.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class TotalPackCountsGrid extends StatelessWidget {
  final TotalPackCountsModel packCounts;

  const TotalPackCountsGrid({
    super.key,
    required this.packCounts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: spacing12,
      mainAxisSpacing: spacing12,
      childAspectRatio: 0.85,
      children: [
        _buildPackCard(
          title: 'SMALL BOX',
          count: packCounts.smallBoxCount,
          color: const Color(0xFF4CAF50),
        ),
        _buildPackCard(
          title: 'BIG BOX',
          count: packCounts.bigBoxCount,
          color: const Color(0xFF2196F3),
        ),
        _buildPackCard(
          title: 'BAG',
          count: packCounts.bagCount,
          color: const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildPackCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing08,
        vertical: spacing10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(spacing06),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForPackType(title),
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: spacing06),
          Flexible(
            child: Text(
              title,
              style: AppTextStyle.bodyLargeBoldDark.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: spacing04),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count.toString(),
              style: AppTextStyle.headingLargeBlack.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPackType(String packType) {
    switch (packType) {
      case 'SMALL BOX':
        return Icons.inventory_2_outlined;
      case 'BIG BOX':
        return Icons.inventory_outlined;
      case 'BAG':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}
