import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class StrukItemRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool isBold;

  const StrukItemRow(this.label, this.value, {super.key, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: kGrey, fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: kBlack,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                fontFamily: isBold ? null : "monospace",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
