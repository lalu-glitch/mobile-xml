import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .start, // Handle text panjang
      children: [
        Text(label, style: const TextStyle(color: kNeutral50, fontSize: 14)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: kBlack,
              fontWeight: .w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
