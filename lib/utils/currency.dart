import 'package:intl/intl.dart';

class CurrencyUtil {
  static String formatCurrency(num? value) {
    final format = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );
    return format.format(value ?? 0);
  }

  static int parseCurrency(String value) {
    // Hapus semua selain angka
    final numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString) ?? 0;
  }
}
