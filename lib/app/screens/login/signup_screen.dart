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
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      context.showErrorSnackBar('Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      context.showErrorSnackBar('Passwords do not match');
      return;
    }

    try {
      await ref.read(loginStateProvider.notifier).signUpWithEmailAndPassword(
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

      if (loginState.isLoggedIn) {
        if (mounted) {
          context.router.replace(AppRoutes.registerPage);
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Signup failed: ${e.toString()}');
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
                padding: EdgeInsets.symmetric(horizontal: spacing16),
              ),
              SizedBox(height: spacing16),
              LoginTextField(
                controller: _passwordController,
                hintText: 'Enter password',
                isPassword: true,
                padding: EdgeInsets.symmetric(horizontal: spacing16),
              ),
              SizedBox(height: spacing16),
              LoginTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm password',
                isPassword: true,
                padding: EdgeInsets.symmetric(horizontal: spacing16),
              ),
              SizedBox(height: spacing20),
              LoginButton(
                label: 'Sign Up',
                onPressed: _handleSignup,
                isLoading: isLoading,
              ),
              _buildLoginLink(),
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
        padding: EdgeInsets.all(spacing16),
        child: Text(
          'Create your account to get started.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.titleMediumDark,
        ),
      );

  Widget _buildLoginLink() => Center(
        child: TextButton(
          onPressed: () => context.router.replace(AppRoutes.loginPage),
          child: Text(
            'Already have an account? Login',
            style: AppTextStyle.titleMediumDark.copyWith(
              color: AppColor.buttonGreen,
            ),
          ),
        ),
      );
}
