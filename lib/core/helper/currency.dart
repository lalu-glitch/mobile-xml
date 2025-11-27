import 'package:intl/intl.dart';

class CurrencyUtil {
  static String formatCurrency(num? value) {
    final format = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    if (value == null || value == 0) return "Rp 0";

    if (value < 0) {
      return "Rp -${format.format(value.abs()).replaceAll("Rp", "").trim()}";
    } else {
      return format.format(value);
    }
  }

  static int parseAmount(String? value) {
    if (value == null || value.isEmpty) return 0;
    String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanValue) ?? 0;
  }
}
