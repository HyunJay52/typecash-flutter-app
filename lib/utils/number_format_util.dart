import 'package:intl/intl.dart';

class NumberFormatUtil {
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  static formatCurrency(num number) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(number);
  }
}