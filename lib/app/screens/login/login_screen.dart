import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/components.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
import 'package:easy_order/app/screens/login/widgets/login_button.dart';
import 'package:easy_order/app/screens/login/widgets/login_text_field.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      context.showErrorSnackBar('Please enter both email and password');
      return;
    }

    try {
      await ref.read(loginStateProvider.notifier).signInWithEmailAndPassword(
            context,
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      final loginState = ref.watch(loginStateProvider);

      if (loginState.error != null && loginState.error!.isNotEmpty) {
        if (mounted) {
          context.showErrorSnackBar(loginState.error!);
        }
        return;
      }

      if (loginState.isLoggedIn && mounted) {
        context.router.replace(AppRoutes.homePage);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Login failed: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginStateProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacer(spacing32),
              _buildAppTitleWithImage(),
              _buildWelcomeText(),
              LoginTextField(
                controller: _emailController,
                hintText: 'Enter email',
                keyboardType: TextInputType.emailAddress,
              ),
              LoginTextField(
                controller: _passwordController,
                hintText: 'Enter password',
                isPassword: true,
                padding: EdgeInsets.only(
                  left: spacing16,
                  right: spacing16,
                  bottom: spacing32,
                ),
              ),
              LoginButton(
                onPressed: _handleLogin,
                isLoading: isLoading,
              ),
              verticalSpacer(spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitleWithImage() => Center(
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
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
          ],
        ),
      );

  Widget _buildWelcomeText() => Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing16),
        child: Text(
          'Please enter your email and password to get started.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.titleMediumDark,
        ),
      );
}
