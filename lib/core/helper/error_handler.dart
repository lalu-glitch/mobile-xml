import 'package:flutter/material.dart';

import 'constant_finals.dart';

class ErrorHandler extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;
  final String message;

  const ErrorHandler({
    super.key,
    required this.onRetry,
    required this.error,
    this.message = 'Gagal memuat data',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(kSize32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, color: kNeutral60, size: kSize64),
            SizedBox(height: kSize16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kSize18,
                fontWeight: FontWeight.w600,
                color: kBlack,
              ),
            ),
            SizedBox(height: kSize8),
            Text(
              'Terjadi kesalahan saat mengambil data dari server. Silakan coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kSize14, color: kNeutral80),
            ),
            SizedBox(height: kSize24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: kWhite),
              label: const Text('Coba Lagi', style: TextStyle(color: kWhite)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kSize12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: kSize12,
                  horizontal: kSize24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
