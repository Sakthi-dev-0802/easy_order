import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/firebase_services/services/order_service.dart';
import 'package:easy_order/app/screens/orders/state/order_notifier.dart';
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
            ? const Center(child: CircularProgressIndicator())
            : orderState.error != null
                ? Center(child: Text(orderState.error!))
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: spacing08,
                            mainAxisSpacing: spacing08,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: orderState.items?.length ?? 0,
                          itemBuilder: (context, index) {
                            if (orderState.items == null ||
                                orderState.items!.isEmpty) {
                              return const Text('No items found');
                            }
                            final item = orderState.items?[index];
                            final originalItems =
                                orderState.originalItems?[index];

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => QuantityUnitDialog(
                                    item: originalItems!,
                                    onConfirm: (quantity, noOfPack, packType) {
                                      ref
                                          .read(
                                              orderStateStateProvider.notifier)
                                          .updateItem(
                                            index,
                                            quantity,
                                            noOfPack,
                                            packType,
                                          );
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 1,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius16),
                                  side: BorderSide(
                                    color: item?.markedForOrder == true
                                        ? AppColor.buttonGreen
                                        : Colors.grey.shade300,
                                    width: item?.markedForOrder == true ? 2 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(spacing16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Column(
                                          spacing: spacing08,
                                          children: [
                                            Image.asset(
                                              'assets/images/tomatto.png',
                                              height: 32,
                                              width: 32,
                                            ),
                                            Text(
                                              item?.itemName ?? '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: spacing16),
                                      _buildAlignedRow(
                                          'Quantity', '${item?.quantity}kg'),
                                      _buildAlignedRow(
                                          'Pack Type', item?.packType ?? ''),
                                      _buildAlignedRow(
                                        'No of Pack',
                                        item?.noOfPack.toString() ?? '',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (orderState.items
                              ?.any((item) => item.markedForOrder == true) ??
                          false)
                        Padding(
                          padding: EdgeInsets.only(top: spacing16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final orderState =
                                    ref.read(orderStateStateProvider);
                                final markedItems = orderState.items
                                        ?.where((item) => item.markedForOrder)
                                        .toList() ??
                                    [];

                                if (markedItems.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select at least one item'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  final user = await AppStorage.getUser;
                                  if (user == null) {
                                    throw Exception('User not found');
                                  }

                                  final order = OrderModel(
                                    uid: const Uuid().v4(),
                                    clientId: widget.client.uid,
                                    lineId: widget.client.lineId,
                                    marketId: widget.client.marketId,
                                    quantity: markedItems.length, 
                                    orderDate: DateTime.now(),
                                    items: markedItems,
                                  );

                                  await OrderService.instance
                                      .createOrder(order);

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Order created successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    context.router.pop();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error creating order: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.buttonGreen,
                                padding:
                                    EdgeInsets.symmetric(vertical: spacing16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius16),
                                ),
                              ),
                              child: const Text(
                                'CONFIRM ORDER',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

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

  Widget _buildAlignedRow(String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: spacing08,
          children: [
            SizedBox(
              width: 90,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
}
