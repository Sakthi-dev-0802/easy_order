import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/screens/login/providers/markets_provider.dart';
import 'package:easy_order/app/screens/login/state/auth_notifier.dart';
import 'package:easy_order/app/screens/login/widgets/login_button.dart';
import 'package:easy_order/core/storage/app_storage.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  MarketModel? _selectedMarket;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedMarket == null) {
      if (mounted) {
        context.showErrorSnackBar('Please fill in all fields');
      }
      return;
    }

    try {
      await ref.read(loginStateProvider.notifier).createUser(
            name: _nameController.text,
            phone: _phoneController.text,
            marketId: _selectedMarket!.marketId,
          );

      final user = ref.watch(loginStateProvider).user;
      if (user != null) {
        await AppStorage.saveUser(user);
        ref.read(userMarketProvider.notifier).state = user.marketId;
        if (mounted) {
          context.router.replace(AppRoutes.landing);
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to create user');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginStateProvider).isLoading;
    final marketsAsync = ref.watch(marketsProvider);

    final markets = marketsAsync.when(
      data: (markets) => markets,
      loading: () => <MarketModel>[],
      error: (_, __) => <MarketModel>[],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register Profile'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacing16),
            child: Column(
              spacing: spacing20,
              children: [
                CustomFormField.text(
                  label: 'Name',
                  controller: _nameController,
                ),
                CustomFormField.text(
                  label: 'Phone Number',
                  controller: _phoneController,
                ),
                CustomFormField.dropdown(
                  label: 'Select Market',
                  value: _selectedMarket?.name,
                  items: markets.map((market) => market.name).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMarket =
                          markets.firstWhere((market) => market.name == value);
                    });
                  },
                ),
                LoginButton(
                  label: 'Submit',
                  padding: EdgeInsets.zero,
                  onPressed: _handleSubmit,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
