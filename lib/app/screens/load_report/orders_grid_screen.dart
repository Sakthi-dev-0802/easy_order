import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/model/order_model.dart';
import 'package:easy_order/app/screens/load_report/state/load_report_notifier.dart';
import 'package:easy_order/app/screens/orders/widgets/quantity_unit_dialog.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersGridScreen extends ConsumerStatefulWidget {
  final List<ItemsModel> items;
  final List<ClientModel> clients;
  final List<OrderModel> orders;
  final DateTime selectedDate;

  const OrdersGridScreen({
    super.key,
    required this.items,
    required this.clients,
    required this.orders,
    required this.selectedDate,
  });

  @override
  ConsumerState<OrdersGridScreen> createState() => _OrdersGridScreenState();
}

class _OrdersGridScreenState extends ConsumerState<OrdersGridScreen> {
  final ScrollController _horizontalHeaderController = ScrollController();
  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _verticalBodyController = ScrollController();
  final ScrollController _verticalItemController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Sync horizontal scroll between header and body
    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.hasClients) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });

    // Sync vertical scroll between items column and body
    _verticalBodyController.addListener(() {
      if (_verticalItemController.hasClients) {
        _verticalItemController.jumpTo(_verticalBodyController.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalBodyController.dispose();
    _verticalItemController.dispose();
    super.dispose();
  }

  /// Check if the selected date is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Format pack text with proper pluralization
  String _formatPackText(int noOfPack, String packType) {
    if (packType == 'pack' || packType.isEmpty) {
      return "$noOfPack ${noOfPack == 1 ? 'pack' : 'packs'}";
    }

    // Handle pluralization for bag/box
    if (packType == 'bag') {
      return "$noOfPack ${noOfPack == 1 ? 'bag' : 'bags'}";
    } else if (packType == 'box') {
      return "$noOfPack ${noOfPack == 1 ? 'box' : 'boxes'}";
    }

    // For any other packType, just use it as-is
    return "$noOfPack $packType${noOfPack == 1 ? '' : 's'}";
  }

  @override
  Widget build(BuildContext context) {
    const double cellWidth = 120;
    const double cellHeight = 80;
    const double headerCellWidth = 150;

    final borderColor = Colors.grey.shade400;
    // Watch state to rebuild when loaded status changes
    final loadReportState = ref.watch(loadReportStatePRovider);
    final notifier = ref.read(loadReportStatePRovider.notifier);
    final isCurrentDate = _isToday(widget.selectedDate);

    if (widget.orders.isEmpty ||
        widget.items.isEmpty ||
        widget.clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: size64,
              color: AppColor.textDarkGray.withOpacity(0.4),
            ),
            SizedBox(height: spacing16),
            Text(
              'No Orders Available',
              style: AppTextStyle.titleMediumDark.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: spacing04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing32),
              child: Text(
                'There are no orders available for this line at the selected date.',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyLargeBoldDark.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.textDarkGray.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ===========================
        // STICKY TOP HEADER ROW (CLIENT NAMES)
        // ===========================
        Row(
          children: [
            // Corner header cell (sticky)
            Container(
              width: headerCellWidth,
              height: cellHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: const Text(
                "Items ↓  |  Clients →",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            // Client headers - horizontally scrollable (synced with body)
            Expanded(
              child: SingleChildScrollView(
                controller: _horizontalHeaderController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children: widget.clients.map((client) {
                    return Container(
                      width: cellWidth,
                      height: cellHeight,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Text(
                        client.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),

        // ===========================
        // SCROLLABLE BODY WITH STICKY LEFT COLUMN
        // ===========================
        Expanded(
          child: Row(
            children: [
              // STICKY LEFT COLUMN (ITEMS) - vertically scrollable (synced with body)
              SingleChildScrollView(
                controller: _verticalItemController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: widget.items.map((item) {
                    return Container(
                      width: headerCellWidth,
                      height: cellHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Text(
                        item.itemName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // SCROLLABLE GRID BODY
              Expanded(
                child: SingleChildScrollView(
                  controller: _verticalBodyController,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  child: SingleChildScrollView(
                    controller: _horizontalBodyController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: List.generate(widget.items.length, (i) {
                        final item = widget.items[i];

                        return Row(
                          children: List.generate(widget.clients.length, (j) {
                            final client = widget.clients[j];

                            // Find the order for this client (handle missing orders)
                            final matchingOrders = widget.orders.where(
                              (o) => o.clientId == client.uid,
                            );
                            final clientOrder = matchingOrders.isEmpty
                                ? null
                                : matchingOrders.first;

                            // Find this item inside the client's order (handle missing items)
                            ItemsModel? orderItem;
                            if (clientOrder != null) {
                              final matchingItems = clientOrder.items.where(
                                (oi) => oi.uid == item.uid,
                              );
                              orderItem = matchingItems.isEmpty
                                  ? null
                                  : matchingItems.first;
                            }

                            final quantity = orderItem?.quantity ?? 0;
                            final noOfPack = orderItem?.noOfPack ?? 0;
                            final packType =
                                orderItem?.packType?.toLowerCase() ?? 'pack';
                            final cellKey = '${item.uid}_${client.uid}';
                            final isLoaded =
                                loadReportState.loadedCells.contains(cellKey);

                            final isEditable = quantity > 0 && isCurrentDate;

                            return Opacity(
                              opacity:
                                  (quantity > 0 && !isCurrentDate) ? 0.6 : 1.0,
                              child: GestureDetector(
                                onTap: isEditable
                                    ? () async {
                                        try {
                                          await notifier.toggleLoadedStatus(
                                              item.uid, client.uid);
                                        } catch (e) {
                                          // Show error message if API call fails
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to update loaded status: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    : null,
                                onLongPress: isEditable && orderItem != null
                                    ? () {
                                        _showEditDialog(
                                          context,
                                          orderItem!,
                                          item.uid,
                                          client.uid,
                                          notifier,
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: cellWidth,
                                  height: cellHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: quantity > 0
                                        ? (isLoaded
                                            ? Colors.green.shade100
                                            : (isCurrentDate
                                                ? Colors.white
                                                : Colors.grey.shade200))
                                        : Colors.grey.shade50,
                                    border: Border.all(
                                      color: isLoaded && quantity > 0
                                          ? Colors.green.shade400
                                          : borderColor,
                                      width: isLoaded && quantity > 0 ? 2 : 1,
                                    ),
                                  ),
                                  child: quantity > 0
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              quantity.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: isLoaded
                                                    ? Colors.green.shade800
                                                    : Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _formatPackText(
                                                  noOfPack, packType),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isLoaded
                                                    ? Colors.green.shade700
                                                    : Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show edit dialog for order item
  void _showEditDialog(
    BuildContext context,
    ItemsModel orderItem,
    String itemId,
    String clientId,
    LoadreportStateNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => QuantityUnitDialog(
        item: orderItem,
        isAlreadyAdded: true,
        onConfirm: ({quantity, noOfPack, packType, isRemoved}) async {
          try {
            await notifier.updateOrderItem(
              itemId: itemId,
              clientId: clientId,
              quantity: quantity ?? 0,
              packType: packType ?? orderItem.packType ?? 'SMALLBOX',
              noOfPack: noOfPack ?? 0,
              isRemoved: isRemoved ?? false,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update order: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
