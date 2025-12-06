import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SecureFooter extends StatelessWidget {
  const SecureFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: kNeutral80),
              const SizedBox(width: 8),
              const Text(
                "Data terenkripsi & diawasi oleh",
                style: TextStyle(
                  color: kNeutral80,
                  fontSize: 12,
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            height: 35,
            color: kWhite,
            child: Image.asset('assets/images/kyc/bi-logo.png'),
          ),
        ),
      ],
    );
  }
}
