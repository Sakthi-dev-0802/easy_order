import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final double size;

  const ProgressBarWidget({
    super.key,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const CircularProgressIndicator(
        color: AppColor.borderGreen,
        strokeCap: StrokeCap.round,
        strokeWidth: 2,
      ),
    );
  }
}
