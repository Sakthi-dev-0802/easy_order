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
  final ItemsModel? item;
  const AddItemPage({super.key, this.item});

  @override
  ConsumerState<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _defaultQuantityController =
      TextEditingController();
  final TextEditingController _noOfPackController = TextEditingController();
  String _selectedPackType = 'SMALL BOX';

  @override
  void initState() {
    super.initState();
    // If editing, populate fields with existing item data
    if (widget.item != null) {
      _itemNameController.text = widget.item!.itemName;
      _defaultQuantityController.text = (widget.item!.quantity ?? 0).toString();
      _selectedPackType = widget.item!.packType ?? 'SMALL BOX';
      _noOfPackController.text = (widget.item!.noOfPack ?? 1).toString();
    } else {
      // Set default value for no of pack when creating new item
      _noOfPackController.text = '1';
    }
  }

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
    final noOfPack = int.tryParse(_noOfPackController.text) ?? 1;

    final item = ItemsModel(
      uid: widget.item?.uid ?? const Uuid().v4(),
      itemName: _itemNameController.text.trim(),
      quantity: defaultQuantity,
      packType: _selectedPackType,
      noOfPack: noOfPack,
    );

    try {
      if (widget.item != null) {
        // Update existing item
        await ref.read(itemStateProvider.notifier).updateItem(item);
        if (mounted) {
          context.showSuccessSnackBar('Item updated successfully');
          context.router.back();
        }
      } else {
        // Create new item
        await ref.read(itemStateProvider.notifier).createItem(item);
        if (mounted) {
          context.showSuccessSnackBar('Item created successfully');
          context.router.back();
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(
            'Failed to ${widget.item != null ? 'update' : 'create'} item: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundWhite,
        title: Text(widget.item != null ? 'Edit Item' : 'Add New Item'),
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
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'Default Quantity',
              controller: _defaultQuantityController,
              hintText: 'Enter default quantity',
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
            SizedBox(height: spacing16),
            CustomFormField.dropdown(
              label: 'Pack Type',
              value: _selectedPackType,
              items: const ['SMALL BOX', 'BIG BOX', 'BAG'],
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
              textCapitalization: TextCapitalization.none,
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

  Widget _buildButtonText() => Text(
        widget.item != null ? 'Update Item' : 'Save Item',
        style: const TextStyle(
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
