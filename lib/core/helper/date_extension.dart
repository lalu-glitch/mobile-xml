extension DateTimeX on DateTime {
  String toIso8601WithOffset() {
    // Ambil format dasar tanpa milidetik (YYYY-MM-DDTHH:mm:ss)
    final baseTime = toIso8601String().split('.').first;

    // Hitung Offset Zona Waktu (misal: +07:00 untuk WIB)
    final offset = timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';

    // PadLeft(2, '0') memastikan angka 7 menjadi "07"
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    // Hasil: 2023-10-27T14:30:05+07:00 (Standar ISO)
    return "$baseTime$sign$hours:$minutes";
  }
}
