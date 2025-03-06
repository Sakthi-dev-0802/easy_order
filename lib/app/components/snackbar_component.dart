import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.bodyTextSmallLightWhite.copyWith(
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.bodyTextSmallLightWhite.copyWith(
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
