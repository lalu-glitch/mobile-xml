import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KYCReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const KYCReadOnlyField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: kNeutral40, thickness: 1),
      ],
    );
  }
}
