import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/screens/items/state/item_notifier.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class AddItemPage extends ConsumerStatefulWidget {
  const AddItemPage({super.key});

  @override
  ConsumerState<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _defaultQuantityController =
      TextEditingController();
  final TextEditingController _noOfPackController = TextEditingController();
  String _selectedPackType = 'BOX';

  @override
  void dispose() {
    _itemNameController.dispose();
    _defaultQuantityController.dispose();
    _noOfPackController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveItem() async {
    if (_itemNameController.text.isEmpty) {
      context.showErrorSnackBar('Please enter item name');
      return;
    }

    final defaultQuantity = int.tryParse(_defaultQuantityController.text) ?? 0;
    final noOfPack = int.tryParse(_noOfPackController.text) ?? 0;

    final item = ItemsModel(
      uid: const Uuid().v4(),
      itemName: _itemNameController.text.trim(),
      quantity: defaultQuantity,
      packType: _selectedPackType,
      noOfPack: noOfPack,
    );

    try {
      await ref.read(itemStateProvider.notifier).createItem(item);
      if (mounted) {
        context.showSuccessSnackBar('Item created successfully');
        context.router.back();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to create item: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundWhite,
        title: const Text('Add New Item'),
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing24),
            CustomFormField.text(
              label: 'Item Name',
              controller: _itemNameController,
              hintText: 'Enter item name',
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'Default Quantity',
              controller: _defaultQuantityController,
              hintText: 'Enter default quantity',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: spacing16),
            CustomFormField.dropdown(
              label: 'Pack Type',
              value: _selectedPackType,
              items: const ['BOX', 'BAG'],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPackType = value;
                  });
                }
              },
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'No of Pack',
              controller: _noOfPackController,
              hintText: 'Enter number of packs',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: spacing32),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() => ElevatedButton(
        onPressed: _handleSaveItem,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.buttonGreen,
          padding: EdgeInsets.symmetric(vertical: spacing16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: ref.watch(itemStateProvider).isLoading
            ? _buildCircularProgress()
            : _buildButtonText(),
      );

  Widget _buildButtonText() => const Text(
        'Save Item',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildCircularProgress() => Center(
        child: SizedBox(
          height: size20,
          width: size20,
          child: const CircularProgressIndicator(
            color: AppColor.backgroundWhite,
            strokeWidth: 2,
          ),
        ),
      );
}
