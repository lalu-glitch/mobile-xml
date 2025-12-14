import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../settings/widgets/widget_detail_row.dart';
import 'widget_copyable.dart';

class SuccessContent extends StatelessWidget {
  final dynamic data; // Ganti 'dynamic' dengan Tipe Model Data Anda

  const SuccessContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Timer / Status Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kYellow.withAlpha(50), // Kuning lembut
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kYellow.withAlpha(100)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, color: Color(0xFF856404)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Selesaikan pembayaran sebelum ${_formatDate(data.expiredAt.toString())}",
                    style: const TextStyle(
                      color: Color(0xFF856404), // Coklat gelap
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Card Nominal (Penting!)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withAlpha(10),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Total Transfer",
                  style: const TextStyle(color: kBlack, fontSize: 14),
                ),
                const SizedBox(height: 8),
                CopyableAmount(
                  amount: data.nominal, // Pastikan tipe num/int/double
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kRed.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "PENTING: Transfer tepat sampai 3 digit terakhir",
                    style: TextStyle(
                      color: kRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Detail Transfer (Bank & Rekening)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withAlpha(10),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail Penerima",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: kBlack,
                  ),
                ),
                const SizedBox(height: 20),
                DetailRow(label: "Bank Tujuan", value: data.bank),
                const Divider(height: 24, color: kWhite),
                CopyableRow(
                  label: "Nomor Rekening",
                  value: data.rekening.toString(),
                  isBold: true,
                ),
                const Divider(height: 24, color: kWhite),
                DetailRow(label: "Keterangan", value: data.keterangan),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month} jam ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }
}
