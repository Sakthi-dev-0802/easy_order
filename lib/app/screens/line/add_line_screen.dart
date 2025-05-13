import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddLinePage extends StatefulWidget {
  const AddLinePage({super.key});

  @override
  State<AddLinePage> createState() => _AddLinePageState();
}

class _AddLinePageState extends State<AddLinePage> {
  final TextEditingController _lineNameController = TextEditingController();

  @override
  void dispose() {
    _lineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: const Text('Add New Line'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing24),
            CustomFormField.text(
              label: 'Line Name',
              controller: _lineNameController,
              hintText: 'Enter line name',
            ),
            SizedBox(height: spacing32),
            ElevatedButton(
              onPressed: () {
                // TODO: Handle save line
                if (_lineNameController.text.isNotEmpty) {
                  print('Saving line: ${_lineNameController.text}');
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
                'Save Line',
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
