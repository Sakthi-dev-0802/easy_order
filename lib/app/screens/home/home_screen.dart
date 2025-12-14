import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/date_format_extension.dart';
import 'package:easy_order/app/components/progress_bar.dart';
import 'package:easy_order/app/components/title_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/providers/date_selection_provider.dart';
import 'package:easy_order/app/screens/home/provider/most_ordered_items_provider.dart';
import 'package:easy_order/app/screens/home/widgets/lines_list.dart';
import 'package:easy_order/app/screens/home/widgets/most_ordered_item.dart';
import 'package:easy_order/app/screens/home/widgets/order_detail_container.dart';
import 'package:easy_order/app/screens/market_info/providers/market_provider.dart';
import 'package:easy_order/core/utils/user_market_provider.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/spacer_component.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? startDate;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().toLocal().toYearFormat();
  }

  void _onDateChanged(DateTime? date) {
    if (date != null) {
      ref.read(dateSelectionProvider.notifier).state = date;
      setState(() {
        selectedDate = date;
        startDate = date.toLocal().toYearFormat();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketAsync = ref.watch(marketInfoProvider);
    final marketId = ref.watch(userMarketProvider);
    final globalDate = ref.watch(dateSelectionProvider);
    final mostOrderedAsync = ref.watch(mostOrderedItemsProvider((
      marketId: marketId ?? '',
      date: globalDate,
    )));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: marketAsync.when(
            data: (market) => Text(market?.name ?? 'Market Details'),
            loading: () => const Text('Loading...'),
            error: (err, stack) => const Text('Error'),
          ),
          forceMaterialTransparency: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => context.router.navigate(AppRoutes.loadLinesPage),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius12),
                    color: AppColor.borderGreen,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Report",
                      style: TextStyle(
                        color: AppColor.iconLight,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: spacing16,
                children: [
                  _buildDropDownFilter(),
                  const TitleComponent(title: "Total Orders"),
                  const OrderDetailContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleComponent(title: "Lines"),
                      _buildAddItemButton(context),
                    ],
                  ),
                  const LinesList(),
                  const TitleComponent(title: "Most Ordered Item"),
                  mostOrderedAsync.when(
                    data: (items) => MostOrderedItem(items: items),
                    loading: () => const Center(
                      child: ProgressBarWidget(),
                    ),
                    error: (err, stack) => Center(
                      child: Text('Error: $err'),
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget _buildDropDownFilter() {
    final selectedDate = ref.watch(dateSelectionProvider);
    return Row(
      children: [
        GestureDetector(
          onTap: () => _openDatePickerDialog(context),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              height: size40,
              child: Row(
                children: [
                  Text(
                    _formatSelectedDate(selectedDate),
                    style: AppTextStyle.titleLargeDark.copyWith(
                      color: AppColor.borderGreen,
                    ),
                  ),
                  horizontalSpacer(spacing08),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: size30,
                    color: AppColor.buttonGreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openDatePickerDialog(BuildContext context) async {
    final now = DateTime.now();
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: oneYearAgo,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.buttonGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    _onDateChanged(picked);
  }

  String _formatSelectedDate(DateTime? selectedDate) {
    String todayFormatted = DateTime.now().toYearFormat();
    final start = selectedDate?.toYearFormat();
    if (selectedDate == null) {
      return 'Today';
    } else if (start == todayFormatted) {
      return 'Today';
    } else {
      return start!;
    }
  }

  Widget _buildAddItemButton(BuildContext context) => GestureDetector(
        onTap: () => context.router.navigate(AppRoutes.addItemPage),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius12),
            color: AppColor.buttonGreen,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                const Text(
                  "Add Item",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
