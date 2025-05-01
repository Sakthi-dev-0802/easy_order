import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;
  final EdgeInsets? padding;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    this.label = 'Login',
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: spacing16),
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          width: double.infinity,
          height: size48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius08),
            color: AppColor.buttonGreen,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: size24,
                    width: size24,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyle.titleLargeLightWhite,
                  ),
          ),
        ),
      ),
    );
  }
}
