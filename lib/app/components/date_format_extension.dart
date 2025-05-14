import 'package:intl/intl.dart';

extension StringDateFormat on DateTime {
  String toYearFormat() {
    return DateFormat('MM/dd/yyyy').format(this);
  }

  DateTime toCalanderDate() => DateFormat('MM/dd/yyyy').parse(toYearFormat());

//Convert to UTC format for usign in API
  String toUTCFormat() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return formatter.format(toUtc());
  }

  String toMonthAndYearFormat() {
    return DateFormat('MMMyy').format(this);
  }
}
