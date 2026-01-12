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
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

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
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
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
              color: AppColor.textDarkGray.withValues(alpha: 0.4),
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
                  color: AppColor.textDarkGray.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TableView.builder(
      verticalDetails:
          ScrollableDetails.vertical(controller: _verticalController),
      horizontalDetails:
          ScrollableDetails.horizontal(controller: _horizontalController),
      pinnedColumnCount: 1, // Sticky Items Column
      pinnedRowCount: 1, // Sticky Clients Header (Top)
      columnCount: widget.clients.length + 1, // +1 for the Items column itself
      rowCount: widget.items.length + 1, // +1 for the Clients header row itself
      columnBuilder: _buildColumnSpan,
      rowBuilder: _buildRowSpan,
      cellBuilder: (context, vicinity) => _buildCell(
        context,
        vicinity,
        isCurrentDate,
        loadReportState,
        notifier,
      ),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const double headerCellWidth = 150;
    const double cellWidth = 120;

    return TableSpan(
      extent: FixedTableSpanExtent(
        index == 0 ? headerCellWidth : cellWidth,
      ),
    );
  }

  TableSpan _buildRowSpan(int index) {
    const double cellHeight = 80;

    return const TableSpan(
      extent: FixedTableSpanExtent(cellHeight),
    );
  }

  TableViewCell _buildCell(
    BuildContext context,
    TableVicinity vicinity,
    bool isCurrentDate,
    LoadreportState loadReportState,
    LoadreportStateNotifier notifier,
  ) {
    final borderColor = Colors.grey.shade400;

    // 1. Top-Left Corner (Sticky Header Intersection)
    if (vicinity.row == 0 && vicinity.column == 0) {
      return TableViewCell(
        child: Container(
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
      );
    }

    // 2. Top Row (Client Headers) - Sticky
    if (vicinity.row == 0) {
      final clientIndex = vicinity.column - 1;
      final client = widget.clients[clientIndex];
      return TableViewCell(
        child: Container(
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
        ),
      );
    }

    // 3. Left Column (Item Headers) - Sticky
    if (vicinity.column == 0) {
      final itemIndex = vicinity.row - 1;
      final item = widget.items[itemIndex];
      return TableViewCell(
        child: Container(
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
        ),
      );
    }

    // 4. Content Cells
    final itemIndex = vicinity.row - 1;
    final clientIndex = vicinity.column - 1;

    final item = widget.items[itemIndex];
    final client = widget.clients[clientIndex];

    // Find the order for this client
    final matchingOrders = widget.orders.where(
      (o) => o.clientId == client.uid,
    );
    final clientOrder = matchingOrders.isEmpty ? null : matchingOrders.first;

    // Find this item inside the client's order
    ItemsModel? orderItem;
    if (clientOrder != null) {
      final matchingItems = clientOrder.items.where(
        (oi) => oi.uid == item.uid,
      );
      orderItem = matchingItems.isEmpty ? null : matchingItems.first;
    }

    final quantity = orderItem?.quantity ?? 0;
    final noOfPack = orderItem?.noOfPack ?? 0;
    final packType = orderItem?.packType?.toLowerCase() ?? 'pack';
    final cellKey = '${item.uid}_${client.uid}';
    final isLoaded = loadReportState.loadedCells.contains(cellKey);
    final isEditable = quantity > 0 && isCurrentDate;

    return TableViewCell(
      child: Opacity(
        opacity: (quantity > 0 && !isCurrentDate) ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: isEditable
              ? () async {
                  try {
                    await notifier.toggleLoadedStatus(item.uid, client.uid);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: quantity > 0
                  ? (isLoaded
                      ? Colors.green.shade100
                      : (isCurrentDate ? Colors.white : Colors.grey.shade200))
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        _formatPackText(noOfPack, packType),
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
      ),
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
