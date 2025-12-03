import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KYCNumberStep extends StatelessWidget {
  final String number;
  final String text;

  const KYCNumberStep({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lingkaran Angka
        Container(
          padding: .all(12),
          decoration: const BoxDecoration(
            color: kNeutral50, // Warna lingkaran abu-abu
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: kBlack,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Teks Instruksi
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: kBlack,
              height: 1.4, // Line height agar nyaman dibaca
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
