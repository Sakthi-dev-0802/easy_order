import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final EdgeInsets padding;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius08),
            borderSide: BorderSide(
              color: AppColor.textDarkGray,
              width: size01,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius08),
            borderSide: BorderSide(
              color: AppColor.textDarkGray,
              width: size01,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
        ),
      ),
    );
  }
}
