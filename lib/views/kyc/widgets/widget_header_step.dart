import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KYCHeader extends StatelessWidget {
  final String step;
  final String title;

  const KYCHeader({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Langkah $step",
          style: const TextStyle(color: kGrey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: kOrange,
            fontSize: 18,
            fontWeight: .bold,
          ),
        ),
      ],
    );
  }
}
