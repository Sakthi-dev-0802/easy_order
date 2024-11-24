import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/components.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EnterMobileNumberPage extends StatefulWidget {
  const EnterMobileNumberPage({super.key});

  @override
  State<EnterMobileNumberPage> createState() => _EnterMobileNumberPageState();
}

class _EnterMobileNumberPageState extends State<EnterMobileNumberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacer(spacing32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Easy Order',
                      style: AppTextStyle.headingXXLargeBlack,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: spacing30,
                        horizontal: spacing24,
                      ),
                      child: Image.asset(
                        'assets/images/bg_image.png',
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing16),
                child: Text(
                  'Please enter your mobile number to get started.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.titleMediumDark,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing16,
                  vertical: spacing20,
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing16),
                child: GestureDetector(
                  onTap: () {
                    //TODO: Login
                    context.navigateTo(AppRoutes.enterOtpPage);
                  },
                  child: Container(
                    width: double.infinity,
                    height: size48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius08),
                      color: AppColor.buttonGreen,
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: AppTextStyle.titleLargeLightWhite,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpacer(spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
