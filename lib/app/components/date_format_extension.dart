import 'package:intl/intl.dart';

extension StringDateFormat on DateTime {
  String toYearFormat() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  DateTime toCalanderDate() => DateFormat('dd/MM/yyyy').parse(toYearFormat());

  String toMonthAndYearFormat() {
    return DateFormat('MMMyy').format(this);
  }
}
