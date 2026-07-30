import 'package:intl/intl.dart';

/// CurrencyFormatter formats numeric amounts to currency representations.
abstract class CurrencyFormatter {
  static final NumberFormat _nairaFormat = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  static final NumberFormat _nairaFormatNoDecimals = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 0,
  );

  /// Formats a double value to Naira currency format (e.g. ₦1,250.50).
  static String formatNaira(double amount) {
    return _nairaFormat.format(amount);
  }

  /// Formats a double value to Naira currency format without decimals if it's a whole number,
  /// otherwise preserves the decimals (e.g., ₦1,250 vs ₦1,250.50).
  static String formatNairaCompact(double amount) {
    if (amount == amount.roundToDouble()) {
      return _nairaFormatNoDecimals.format(amount);
    }
    return _nairaFormat.format(amount);
  }
}
