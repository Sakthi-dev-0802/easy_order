import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.navigateTo(AppRoutes.loginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColor.buttonGreen,
          strokeWidth: size02,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
