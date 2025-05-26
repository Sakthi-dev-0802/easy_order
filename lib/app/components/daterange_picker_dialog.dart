import 'package:easy_order/app/constants/radius_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class CustomDateRangePickerDialog extends StatelessWidget {
  final DateRange? initialDateRange;
  final Function(DateRange?) onDateRangeChanged;

  const CustomDateRangePickerDialog({
    super.key,
    required this.initialDateRange,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    DateRange? selectedDate = initialDateRange;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: DateRangePickerWidget(
            maximumDateRangeLength: 50,
            minimumDateRangeLength: 1,
            doubleMonth: false,
            initialDateRange: initialDateRange,
            initialDisplayedDate: now,
            maxDate: now,
            minDate: oneYearAgo,
            onDateRangeChanged: (selectedDateRange) {
              selectedDate = selectedDateRange;
            },
            allowSingleTapDaySelection: true,
            height: 400,
            theme: const CalendarTheme(
              selectedColor: Color(0xFF298F05),
              dayNameTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              monthTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              inRangeColor: Color(0xFF2196F3),
              inRangeTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              todayTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF298F05),
              ),
              defaultTextStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              radius: 10.0,
              tileSize: 40.0,
              disabledTextStyle: TextStyle(color: Colors.grey),
              quickDateRangeBackgroundColor: Color(0xFFFFF9F9),
              selectedQuickDateRangeColor: Colors.blue,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: AppTextStyle.bodyLargeBoldDark,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.buttonGreen,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                radius12,
              ),
            ),
            elevation: 2,
          ),
          onPressed: () {
            onDateRangeChanged(selectedDate);
            Navigator.of(context).pop();
          },
          child: Text("Confirm",
              style: AppTextStyle.bodyLargeBoldDark.copyWith(
                color: AppColor.textWhite,
              )),
        ),
      ],
    );
  }
}
