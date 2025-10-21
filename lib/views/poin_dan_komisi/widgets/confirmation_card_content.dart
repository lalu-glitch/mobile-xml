import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import 'confirmation_summary.dart';
import 'custom_painter_helper.dart';
import 'text_helper.dart';

// [KODE YANG DIMODIFIKASI]
class ConfirmationCardContent extends StatelessWidget {
  const ConfirmationCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextTitle('Detail Tukar Poin'),
                const TextSub(
                  'Mohon konfirmasi permintaan tukar poin berikut ini',
                ),

                // --- PERUBAHAN DI SINI ---
                // Mengganti SizedBox(height: 30) dengan DottedDivider
                // yang diberi padding vertikal.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: DottedDivider(
                    color: kOrange, // Dibuat lebih samar
                    strokeWidth: 1.5,
                  ),
                ),

                // const SizedBox(height: 30), // <-- Kode lama ini diganti
                const InfoText('Nama Agen', 'SEO XML Tronik'),

                // --- AKHIR PERUBAHAN ---
                const InfoText('ID Agen', 'XML112233'),

                const TextLabel('Hadiah Tukar Poin'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/promo.jpg',
                      width: 88,
                      height: 88,
                      // Placeholder jika gambar tidak ada
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 88,
                          height: 88,
                          color: kNeutral80,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: kWhite,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody('Voucher XL Combo Flex'),
                        TextSub('Qty: 1 Ton'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const ConfirmationSummary(),
      ],
    );
  }
}
