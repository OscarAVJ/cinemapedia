import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number, [decimals = 0]) {
    final formatedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formatedNumber;
  }
}
