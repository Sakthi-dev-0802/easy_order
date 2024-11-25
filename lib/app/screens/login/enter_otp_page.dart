import 'package:auto_route/annotations.dart';
import 'package:easy_order/app/components/components.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({super.key});

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundWhite,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              verticalSpacer(spacing24),
              Text(
                'Enter confirmation code',
                style: AppTextStyle.headingXLargeBlack,
              ),
              verticalSpacer(spacing16),
              Text(
                'A 4-digit code was sent to +91 9788430703',
                style: AppTextStyle.bodyLargeBoldDark,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing16,
                  vertical: spacing24,
                ),
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  animationDuration: Duration.zero,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      // isOtpValid = value.length == otpLenght;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing16),
                child: GestureDetector(
                  onTap: () {
                    //TODO: Login
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
            ],
          ),
        ),
      ),
    );
  }
}
