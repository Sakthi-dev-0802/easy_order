import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/screens/orders/state/order_notifier.dart';
import 'package:easy_order/app/screens/orders/widgets/item_card.dart';
import 'package:easy_order/app/screens/orders/widgets/quantity_unit_dialog.dart';
import 'package:easy_order/core/storage/app_storage.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class OrderTakingPage extends ConsumerStatefulWidget {
  final ClientModel client;
  const OrderTakingPage({super.key, required this.client});

  @override
  ConsumerState<OrderTakingPage> createState() => _OrderTakingPageState();
}

class _OrderTakingPageState extends ConsumerState<OrderTakingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderStateStateProvider.notifier).getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderStateStateProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: orderState.isLoading
            ? _buildProgressBar(false)
            : orderState.error != null
                ? _buildErrorText(orderState)
                : Column(
                    children: [
                      _buildContent(orderState),
                      if (orderState.items
                              ?.any((item) => item.markedForOrder == true) ??
                          false)
                        _buildOrderConfirmButton(context),
                    ],
                  ),
      ),
    );
  }

  Widget _buildOrderConfirmButton(BuildContext context) {
    final orderState = ref.watch(orderStateStateProvider);
    return Padding(
      padding: EdgeInsets.only(top: spacing16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await createOrder();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.buttonGreen,
            padding: EdgeInsets.symmetric(vertical: spacing16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius16),
            ),
          ),
          child: orderState.isCreatingOrder
              ? _buildProgressBar(true)
              : const Text(
                  'CONFIRM ORDER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildContent(OrderStateState orderState) => Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: spacing08,
            mainAxisSpacing: spacing08,
            childAspectRatio: 0.9,
          ),
          itemCount: orderState.items?.length ?? 0,
          itemBuilder: (context, index) {
            if (orderState.items == null || orderState.items!.isEmpty) {
              return const Text('No items found');
            }
            final item = orderState.items?[index];
            final originalItems = orderState.originalItems?[index];

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => QuantityUnitDialog(
                    item: originalItems!,
                    onConfirm: (quantity, noOfPack, packType) {
                      ref.read(orderStateStateProvider.notifier).updateItem(
                            index,
                            quantity,
                            noOfPack,
                            packType,
                          );
                    },
                  ),
                );
              },
              child: ItemCard(item: item),
            );
          },
        ),
      );

  Widget _buildErrorText(OrderStateState orderState) =>
      Center(child: Text(orderState.error!));

  Widget _buildProgressBar(bool isInsideButton) => Center(
        child: SizedBox(
          height: isInsideButton ? size24 : size32,
          width: isInsideButton ? size24 : size32,
          child: CircularProgressIndicator(
            color: isInsideButton
                ? AppColor.backgroundWhite
                : AppColor.borderGreen,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
          ),
        ),
      );

  AppBar _buildAppBar() => AppBar(
        title: Text(
          '${widget.client.name} Order',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
      );

  Future<void> createOrder() async {
    final orderState = ref.read(orderStateStateProvider);
    final markedItems =
        orderState.items?.where((item) => item.markedForOrder).toList() ?? [];

    if (markedItems.isEmpty) {
      context.showErrorSnackBar('Please select at least one item');
      return;
    }

    try {
      final user = await AppStorage.getUser;
      if (user == null) {
        throw Exception('User not found');
      }

      final totalQuantity = markedItems
          .map((item) => item.quantity ?? 0)
          .fold(0, (sum, quantity) => sum + quantity);

      final order = OrderModel(
        uid: const Uuid().v4(),
        clientId: widget.client.uid,
        lineId: widget.client.lineId,
        marketId: widget.client.marketId,
        quantity: totalQuantity,
        orderDate: DateTime.now(),
        items: markedItems,
      );

      await ref.read(orderStateStateProvider.notifier).createOrder(order);

      if (mounted) {
        context.showSuccessSnackBar('Order created successfully');
        context.router.back();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Error creating order: ${e.toString()}');
      }
    }
  }
}
