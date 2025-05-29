import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  // Body Text
  // 12, 13, 14
  static final TextStyle bodyTextSmallLightWhite = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.textWhite,
  );

  static final TextStyle bodyLargeBoldDark = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.textDark,
  );

  // Title Text
  // 15, 16, 17, 18
  static final TextStyle titleMediumDark = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.textDarkGray,
  );

  static final TextStyle titleMediumLightDark = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.textDarkGray1,
  );

  static final TextStyle titleLargeLightWhite = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textWhite,
  );

  static final TextStyle titleLargeDark = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textDarkGray,
  );
  // Subheading Text
  // 20, 21, 22, 23, 24
  // static final TextStyle subHeadingLargeBlack = GoogleFonts.inter(
  //   fontSize: 20,
  //   fontWeight: FontWeight.w500,
  //   color: AppColor.textBlack,
  // );

  // Heading Text
  // Above 24
  static final TextStyle headingLargeBlack = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );
  static final TextStyle headingXLargeBlack = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColor.textBlack,
  );
  static final TextStyle headingXXLargeBlack = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColor.textBlack,
  );

  // Button Label Text Styles
  // 12, 13, 14
  // static final TextStyle buttonLargeWhite = GoogleFonts.inter(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w500,
  //   color: AppColor.textWhite,
  // );
}
