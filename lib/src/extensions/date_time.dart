import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get formatDate {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
