import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _nairaFormat = NumberFormat.currency(
    symbol: '₦',
    decimalDigits: 2,
    locale: 'en_NG',
  );

  static final _nairaCompactFormat = NumberFormat.compactCurrency(
    symbol: '₦',
    decimalDigits: 2,
    locale: 'en_NG',
  );

  static String formatNaira(num? amount) {
    if (amount == null) return '₦0.00';
    return _nairaFormat.format(amount);
  }

  static String formatNairaCompact(num? amount) {
    if (amount == null) return '₦0.00';
    return _nairaCompactFormat.format(amount);
  }
}
