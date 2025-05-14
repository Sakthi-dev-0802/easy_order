import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/date_format_extension.dart';
import 'package:easy_order/app/components/daterange_picker_dialog.dart';
import 'package:easy_order/app/components/title_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/home/widgets/lines_list.dart';
import 'package:easy_order/app/screens/home/widgets/most_ordered_item.dart';
import 'package:easy_order/app/screens/home/widgets/order_detail_container.dart';
import 'package:easy_order/app/screens/market_info/providers/market_provider.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/spacer_component.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateRange? selectedDateRange;
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().toCalanderDate().toUTCFormat();
    endDate = null;
  }

  void _onDateRangeChanged(DateRange? dateRange) {
    setState(() {
      if (dateRange != null) {
        selectedDateRange = dateRange;
        startDate = selectedDateRange!.start.toUTCFormat();

        endDate = selectedDateRange!.end == selectedDateRange!.start
            ? DateTime.now().toUTCFormat()
            : selectedDateRange!.end
                .add(const Duration(days: 1))
                .subtract(const Duration(milliseconds: 1))
                .toUTCFormat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketAsync = ref.watch(marketInfoProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: marketAsync.when(
            data: (market) => Text(market?.name ?? 'Market Details'),
            loading: () => const Text('Loading...'),
            error: (err, stack) => const Text('Error'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius12),
                  color: AppColor.borderGreen,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("data"),
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
                  const TitleComponent(title: "Lines"),
                  const LinesList(),
                  const TitleComponent(title: "Most Ordered Item"),
                  const MostOrderedItem()
                ],
              )),
        ));
  }

  Widget _buildDropDownFilter() {
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
                    _formatSelectedDateRange(selectedDateRange),
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

  Future<void> _openDatePickerDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return CustomDateRangePickerDialog(
            initialDateRange: selectedDateRange,
            onDateRangeChanged: (dateRange) => _onDateRangeChanged(dateRange),
          );
        },
      );

  String _formatSelectedDateRange(DateRange? dateRange) {
    String todayFormatted = DateTime.now().toYearFormat();
    final start = dateRange?.start.toYearFormat();
    final end = dateRange?.end.toYearFormat();
    if (dateRange == null) {
      return 'Today';
    } else if (start == todayFormatted && end == todayFormatted) {
      return 'Today';
    } else if (dateRange.start == dateRange.end) {
      return start!;
    } else {
      return '$start - $end';
    }
  }
}
