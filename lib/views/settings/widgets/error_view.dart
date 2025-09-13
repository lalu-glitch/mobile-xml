import 'package:flutter/material.dart';

import '../../../core/constant_finals.dart';

class ErrorView extends StatelessWidget {
  final String state;
  final Future<void> onRetry;

  const ErrorView({super.key, required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: kRed),
            const SizedBox(height: 16),
            Text(
              "Terjadi kesalahan",
              style: Styles.kNunitoBold.copyWith(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state,
              textAlign: TextAlign.center,
              style: Styles.kNunitoRegular.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // trigger reload InfoAkunCubit
                onRetry;
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                "Coba Lagi",
                style: Styles.kNunitoMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
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
