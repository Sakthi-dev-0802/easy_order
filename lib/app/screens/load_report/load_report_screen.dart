import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/progress_bar.dart';
import 'package:easy_order/app/providers/date_selection_provider.dart';
import 'package:easy_order/app/screens/load_report/orders_grid_screen.dart';
import 'package:easy_order/app/screens/load_report/state/load_report_notifier.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoadReportPage extends ConsumerStatefulWidget {
  final String lineId;
  final String lineName;

  const LoadReportPage({
    super.key,
    required this.lineId,
    required this.lineName,
  });

  @override
  ConsumerState<LoadReportPage> createState() => _LoadReportPageState();
}

class _LoadReportPageState extends ConsumerState<LoadReportPage> {
  @override
  void initState() {
    super.initState();
    final globalDate = ref.read(dateSelectionProvider);
    Future.microtask(() {
      ref.read(loadReportStatePRovider.notifier).getReportData(
            widget.lineId,
            globalDate,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loadReportStatePRovider);
    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColor.backgroundWhite,
        body: Center(child: ProgressBarWidget()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: AppColor.backgroundWhite,
        body: Center(child: Text("Error: ${state.error}")),
      );
    }

    final items = state.items ?? [];
    final clients = state.clients ?? [];
    final orders = state.orders ?? [];
    final selectedDate = ref.watch(dateSelectionProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: Text(widget.lineName),
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: OrdersGridScreen(
        items: items,
        clients: clients,
        orders: orders,
        selectedDate: selectedDate,
      ),
    );
  }
}
