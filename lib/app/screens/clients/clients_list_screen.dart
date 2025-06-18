import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/screens/clients/providers/orders_provider.dart';
import 'package:easy_order/app/screens/clients/widgets/add_client_floating_button.dart';
import 'package:easy_order/app/screens/clients/widgets/client_card.dart';
import 'package:easy_order/app/screens/clients/widgets/quantity_hero_card.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ClientsListPage extends ConsumerWidget {
  final String? lineId;
  final String? lineName;

  const ClientsListPage({
    super.key,
    this.lineId,
    this.lineName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsByLineProvider(lineId ?? ''));

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: _buildAppBar(context),
      floatingActionButton: AddClientFloatingButton(lineId: lineId),
      body: Column(
        children: [
          QuantityHeroCard(lineId: lineId ?? ''),
          _buildBodayWidget(clientsAsync),
        ],
      ),
    );
  }

  Widget _buildBodayWidget(AsyncValue<List<ClientModel>> clientsAsync) =>
      Expanded(
        child: clientsAsync.when(
          data: (clients) {
            if (clients.isEmpty) {
              return _buildEmptyView();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ClientCard(client: client);
              },
            );
          },
          loading: () => _buildCircularProgress(),
          error: (error, stackTrace) => _buildErrorWidget(),
        ),
      );

  Widget _buildCircularProgress() => Center(
        child: SizedBox(
          width: size32,
          height: size32,
          child: const CircularProgressIndicator(
            color: AppColor.buttonGreen,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
          ),
        ),
      );

  Widget _buildErrorWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacing16,
          children: [
            Icon(
              Icons.error_outline,
              size: size64,
              color: AppColor.textDarkGray.withOpacity(0.5),
            ),
            Text(
              'Error loading clients',
              style: AppTextStyle.titleMediumDark,
            ),
          ],
        ),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text(
          lineName ?? 'Clients List',
          style: AppTextStyle.titleLargeLightWhite.copyWith(
            color: AppColor.textBlack,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        actions: [
          _buildLineEditButton(context),
        ],
      );

  Widget _buildLineEditButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          context.router.push(AppRoutes.addLinePage(
            lineId: lineId,
            lineName: lineName,
          ));
        },
      );

  Widget _buildEmptyView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacing16,
          children: [
            Icon(
              Icons.people_outline,
              size: size64,
              color: AppColor.textDarkGray.withOpacity(0.5),
            ),
            Text(
              'No clients found',
              style: AppTextStyle.titleMediumDark,
            ),
          ],
        ),
      );
}
