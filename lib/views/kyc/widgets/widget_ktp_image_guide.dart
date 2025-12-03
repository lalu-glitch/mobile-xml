import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KTPImageGuideSection extends StatelessWidget {
  final String imageValid;
  final String imageInvalid;
  const KTPImageGuideSection({
    super.key,
    required this.imageValid,
    required this.imageInvalid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Gambar Kiri (Benar)
        Expanded(
          child: Column(
            children: [
              _buildImageContainer(isCorrect: true, asset: imageValid),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, color: kGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Benar",
                    style: TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Gambar Kanan (Salah)
        Expanded(
          child: Column(
            children: [
              _buildImageContainer(isCorrect: false, asset: imageInvalid),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cancel, color: kRed, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Salah",
                    style: TextStyle(
                      color: kRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer({
    required bool isCorrect,
    required String asset,
  }) {
    return AspectRatio(
      aspectRatio: 1.5, // Rasio kartu standar
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F2), // Placeholder background
          borderRadius: BorderRadius.circular(8),
          // Simulasi gambar KTP
          image: DecorationImage(
            image: //image asset AssetImage('assets/images/ktp_sample.png'),
            AssetImage(
              asset,
            ),
            fit: isCorrect
                ? BoxFit.contain
                : BoxFit.contain, // Fit logic: Cover (Full) vs Contain (Kecil)
            scale: isCorrect ? 1.0 : 2.0, // Scale logic simulation
          ),
        ),
      ),
    );
  }
}
