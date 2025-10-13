import 'package:flutter/material.dart';

import 'confirmation_summary.dart';
import 'text_helper.dart';

class ConfirmationCardContent extends StatelessWidget {
  const ConfirmationCardContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTitle('Detail Tukar Poin'),
        const TextSub('Mohon konfirmasi permintaan tukar poin berikut ini'),
        const SizedBox(height: 30),

        // === INFORMASI AGEN ===
        const InfoText('Nama Agen', 'SEO XML Tronik'),
        const InfoText('ID Agen', 'XML112233'),

        const TextLabel('Hadiah Tukar Poin'),
        const SizedBox(height: 8),
        Row(
          children: [
            Image.asset('assets/images/promo.jpg', width: 88, height: 88),
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
        const Spacer(),
        const ConfirmationSummary(),
      ],
    );
  }
}
