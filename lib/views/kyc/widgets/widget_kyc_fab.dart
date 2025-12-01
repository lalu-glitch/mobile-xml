import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KYCFloatingActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const KYCFloatingActionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: kOrange,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Icon panah memberikan affordance "Lanjut"
          label: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kWhite,
            ),
          ),
        ),
      ),
    );
  }
}
