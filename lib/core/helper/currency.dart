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
    // Hapus semua kecuali angka dan satu koma/titik untuk desimal (opsional)
    final onlyDigitsAndCommaDot = value.replaceAll(RegExp(r'[^0-9.,]'), '');
    // Ganti koma jadi titik supaya parse bisa (jika ada desimal)
    final normalized = onlyDigitsAndCommaDot.replaceAll(',', '.');
    // Jika ada titik, coba parse sebagai double dulu lalu bulatkan
    if (normalized.contains('.')) {
      final double? d = double.tryParse(normalized);
      return d?.round() ?? 0;
    }
    return int.tryParse(normalized) ?? 0;
  }
}
