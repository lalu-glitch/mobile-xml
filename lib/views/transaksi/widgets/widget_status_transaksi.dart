import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import 'widget_pulse_loader.dart';

/// class yang handle status proses transaksi [gemini]
class GenericStatusView extends StatelessWidget {
  final String title;
  final String message;
  final bool isLoading;
  final bool isError;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onPressed;

  const GenericStatusView({
    super.key,
    required this.title,
    required this.message,
    this.isLoading = false,
    this.isError = false,
    this.showButton = false,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna dan Icon
    final themeColor = isError ? kRed : kOrange; // kRed / kOrange
    final statusIcon = isError
        ? Icons.close_rounded
        : Icons.hourglass_top_rounded;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. VISUALIZATION (Pulse Animation)
            if (isLoading)
              FintechPulseLoader(color: themeColor, icon: statusIcon)
            else
              // Jika Error/Static, tampilkan icon diam tapi tetap cantik
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: themeColor.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, size: 40, color: themeColor),
              ),

            const SizedBox(height: 40),

            // 2. TEXT CONTENT
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kBlack,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: kGrey, height: 1.5),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // 3. ACTION BUTTON (Bottom Floating)
            if (showButton) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Pill shape (Standar Fintech)
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    buttonText ?? "Kembali",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}
