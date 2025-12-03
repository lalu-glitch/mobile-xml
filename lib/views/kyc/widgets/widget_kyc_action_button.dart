import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KYCActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const KYCActionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .symmetric(horizontal: 24.0, vertical: 16.0),

      child: SizedBox(
        height: 50, // Tinggi fix agar tombol terlihat solid
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            elevation: 0, // Flat, lebih ringan render-nya daripada elevation 4
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Hapus splash/ripple berat jika mau ultra-performant,
            // tapi default biasanya sudah cukup oke.
          ),
          child: Text(
            title,
            style: const TextStyle(
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
