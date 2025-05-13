import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedLine;

  final List<String> _lines = [
    'Perumanallur Line',
    'Coimbatore Line',
    'Tirupur Line',
    'Erode Line'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
            CustomFormField.dropdown(
              label: 'Select Line',
              value: _selectedLine,
              items: _lines,
              onChanged: (value) {
                setState(() {
                  _selectedLine = value;
                });
              },
            ),
            SizedBox(height: spacing16),
            CustomFormField.text(
              label: 'Address',
              controller: _addressController,
              hintText: 'Enter address',
            ),
            SizedBox(height: spacing32),
            ElevatedButton(
              onPressed: () {
                // TODO: Handle save client
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _addressController.text.isNotEmpty &&
                    _selectedLine != null) {
                  print('Saving client: ${_nameController.text}');
                  context.router.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonGreen,
                padding: EdgeInsets.symmetric(vertical: spacing16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Client',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
