import 'package:easy_order/app/components/spacer_component.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ButtonComponent extends StatelessWidget {
  final String? label;
  final String? icon;
  final double? iconSize;
  final TextStyle? labelStyle;
  final EdgeInsets? insidePadding;
  final Color? buttonColor;
  final Color? iconColor;
  final Color? labelColor;
  final double? radius;
  final Border? border;
  final VoidCallback? onTap;

  const ButtonComponent({
    super.key,
    this.label,
    this.icon,
    this.iconSize,
    this.labelStyle,
    this.insidePadding,
    this.buttonColor,
    this.radius = 8,
    this.border,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  factory ButtonComponent.filled({
    required String label,
    String? icon,
    required VoidCallback? onTap,
    TextStyle? labelStyle,
    EdgeInsets? insidePadding,
  }) =>
      ButtonComponent(
        label: label,
        labelStyle: labelStyle,
        icon: icon,
        onTap: onTap,
        insidePadding: insidePadding,
        buttonColor:
            onTap != null ? AppColor.buttonPrimary : AppColor.borderGreen,
        labelColor: Colors.green,
        iconColor: Colors.green,
      );

  factory ButtonComponent.outlined({
    required String label,
    String? icon,
    required VoidCallback? onTap,
    TextStyle? labelStyle,
    EdgeInsets? insidePadding,
  }) =>
      ButtonComponent(
        label: label,
        labelStyle: labelStyle,
        icon: icon,
        onTap: onTap,
        insidePadding: insidePadding,
        border: Border.all(
          color: AppColor.borderGreen,
        ),
        labelColor: AppColor.textDarkGray,
        iconColor: AppColor.iconLight,
        buttonColor: onTap != null ? Colors.transparent : AppColor.buttonGreen,
      );

  factory ButtonComponent.text({
    required String label,
    String? icon,
    required VoidCallback? onTap,
    TextStyle? labelStyle,
  }) =>
      ButtonComponent(
        label: label,
        icon: icon,
        onTap: onTap,
        labelStyle: labelStyle,
        labelColor: AppColor.textDarkGray,
        iconColor: AppColor.iconLight,
      );

  factory ButtonComponent.filledIcon({
    String? icon,
    required VoidCallback? onTap,
  }) =>
      ButtonComponent(
        icon: icon,
        onTap: onTap,
        buttonColor: AppColor.buttonPrimary,
        iconColor: AppColor.iconLight,
        radius: radius40,
        insidePadding:
            EdgeInsets.symmetric(vertical: spacing12, horizontal: spacing12),
        iconSize: size32,
      );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: onTap != null ? buttonColor : AppColor.buttonGreen,
            borderRadius: BorderRadius.circular(radius ?? 0),
            border: border,
          ),
          padding: insidePadding ??
              EdgeInsets.symmetric(
                horizontal: spacing12,
                vertical: spacing08,
              ),
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Image(
            image: AssetImage(icon!),
            height: iconSize ?? size20,
            width: iconSize ?? size20,
            color: iconColor,
          ),
          if (label != null)
            horizontalSpacer(
              spacing08,
            )
        ],
        if (label != null)
          Text(
            label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: labelStyle ??
                AppTextStyle.titleMediumDark.copyWith(
                  color: AppColor.borderGreen,
                ),
          ),
      ],
    );
  }
}
