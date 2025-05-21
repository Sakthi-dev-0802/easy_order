import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/screens/clients/state/client_notifier.dart';
import 'package:easy_order/core/utils/user_market_service.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class AddClientPage extends ConsumerStatefulWidget {
  final String? lineId;
  const AddClientPage({super.key, this.lineId});

  @override
  ConsumerState<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends ConsumerState<AddClientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveClient() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      final marketId = UserMarketService.userMarket;
      if (marketId == null) {
        if (mounted) {
          context.showErrorSnackBar('Market ID not found. Please try again.');
        }
        return;
      }

      final client = ClientModel(
        uid: const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        lineId: widget.lineId ?? '',
        marketId: marketId,
      );

      try {
        await ref.read(clientStateProvider.notifier).createClient(client);
        if (mounted) {
          context.router.back();
        }
      } catch (e) {
        if (mounted) {
          context.showErrorSnackBar('Failed to create client: ${e.toString()}');
        }
      }
    } else {
      context.showErrorSnackBar('Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: const Text('Add New Client'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing24),
            CustomFormField.text(
              label: 'Client Name',
              controller: _nameController,
              hintText: 'Enter client name',
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'Phone Number',
              controller: _phoneController,
              hintText: 'Enter phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'Address',
              controller: _addressController,
              hintText: 'Enter address',
            ),
            SizedBox(height: spacing32),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() => ElevatedButton(
        onPressed: _handleSaveClient,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.buttonGreen,
          padding: EdgeInsets.symmetric(vertical: spacing16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: ref.watch(clientStateProvider).isLoading
            ? _buildCircularProgress()
            : _buildButtonText(),
      );

  Widget _buildButtonText() => const Text(
        'Save Client',
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
