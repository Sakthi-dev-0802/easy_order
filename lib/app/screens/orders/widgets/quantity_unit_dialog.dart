import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class QuantityUnitDialog extends StatefulWidget {
  final ItemsModel item;
  final bool isAlreadyAdded;
  final Function(
      {int? quantity,
      int? noOfPack,
      String? packType,
      bool? isRemoved}) onConfirm;

  const QuantityUnitDialog({
    super.key,
    required this.item,
    required this.isAlreadyAdded,
    required this.onConfirm,
  });

  @override
  State<QuantityUnitDialog> createState() => _QuantityUnitDialogState();
}

class _QuantityUnitDialogState extends State<QuantityUnitDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _noOfPackController;
  String _selectedPackType = 'BOX';

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _noOfPackController = TextEditingController();
    _quantityController.text = (widget.item.quantity ?? 0).toString();
    _selectedPackType = (widget.item.packType ?? 'BOX');
    _noOfPackController.text = (widget.item.noOfPack ?? 1).toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noOfPackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing20),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/tomatto.png',
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(height: spacing08),
                      Text(
                        widget.item.itemName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing16),
                if (widget.isAlreadyAdded)
                  IconButton(
                    onPressed: () {
                      widget.onConfirm(isRemoved: true);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                SizedBox(height: spacing16),
                _buildInputField(
                  label: 'Quantity (kg)',
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: spacing12),
                _buildInputField(
                  label: 'Pack Type',
                  controller: _noOfPackController,
                  keyboardType: TextInputType.number,
                  isPackType: true,
                ),
                SizedBox(height: spacing12),
                _buildInputField(
                  label: 'No of Pack',
                  controller: _noOfPackController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: spacing20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.bodyLargeBoldDark
                            .copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: spacing08),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonGreen,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing24,
                          vertical: spacing12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius12),
                        ),
                      ),
                      onPressed: () {
                        final quantity =
                            int.tryParse(_quantityController.text) ?? 0;
                        final noOfPack =
                            int.tryParse(_noOfPackController.text) ?? 0;
                        widget.onConfirm(
                          quantity: quantity,
                          noOfPack: noOfPack,
                          packType: _selectedPackType,
                          isRemoved: false,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CONFIRM',
                        style: AppTextStyle.bodyLargeBoldDark.copyWith(
                          fontSize: 18,
                          color: AppColor.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool isPackType = false,
  }) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isPackType
                ? CustomFormField.dropdown(
                    label: '',
                    value: _selectedPackType,
                    items: const ['BOX', 'BAG'],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPackType = value;
                        });
                      }
                    },
                  )
                : CustomFormField.text(
                    label: '',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    controller: controller,
                  ),
          ),
        ],
      ),
    );
  }
}
