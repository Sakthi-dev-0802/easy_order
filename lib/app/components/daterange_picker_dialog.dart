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
              selectedColor: Colors.blue,
              dayNameTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              monthTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              inRangeColor: Colors.blueAccent,
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
                color: Colors.red,
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
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onDateRangeChanged(selectedDate);
            Navigator.of(context).pop();
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
