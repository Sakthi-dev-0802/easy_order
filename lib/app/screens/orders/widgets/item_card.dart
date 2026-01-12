import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final ItemsModel? item;
  const ItemCard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius16),
        side: BorderSide(
          color: item?.markedForOrder == true
              ? AppColor.buttonGreen
              : Colors.grey.shade300,
          width: item?.markedForOrder == true ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  spacing: spacing08,
                  children: [
                    Image.asset(
                      'assets/images/tomatto.png',
                      height: 32,
                      width: 32,
                    ),
                    Text(
                      item?.itemName ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing16),
              _buildAlignedRow('Quantity', '${item?.quantity}kg'),
              _buildAlignedRow('Pack Type', item?.packType ?? ''),
              _buildAlignedRow(
                'No of Pack',
                item?.noOfPack.toString() ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlignedRow(String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: spacing08,
          children: [
            _buildLeftContent(label),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );

  Widget _buildLeftContent(String label) => SizedBox(
        width: 90,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
}
