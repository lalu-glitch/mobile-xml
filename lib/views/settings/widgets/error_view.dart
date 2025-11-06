import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final Future<void> Function() onRetry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon error untuk visual feedback
            const Icon(Icons.error_outline, size: 80, color: kRed),
            const SizedBox(height: 16),
            Text(
              "Terjadi kesalahan",
              style: TextStyle(fontSize: 20, color: kBlack),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: kNeutral80),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await onRetry();
              },
              icon: const Icon(Icons.refresh, color: kWhite),
              label: Text(
                "Coba Lagi",
                style: TextStyle(color: kWhite, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
