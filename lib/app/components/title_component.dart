import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  const TitleComponent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyle.titleLargeDark,
        )
      ],
    );
  }
}
