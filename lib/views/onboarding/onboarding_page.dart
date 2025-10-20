import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import 'onboarding_page_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData content;
  const OnboardingPage({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Logo (ukurannya tetap, tidak masalah)
            Image.asset(
              'assets/images/logo_onboarding.png',
              width: kSize50 * 3,
            ),

            // 2. Ganti SizedBox(32) dengan Spacer
            const Spacer(flex: 1), // Ambil 1 bagian ruang
            // 3. Buat gambar utama fleksibel
            Expanded(
              flex: 4, // Beri 4 bagian ruang (lebih banyak)
              child: Image.asset(
                content.imagePath,
                width: double.infinity,
                fit: BoxFit.contain, // Pastikan gambar muat tanpa distorsi
                // HAPUS 'height: kSize100 * 4'
              ),
            ),

            // 4. Ganti SizedBox(69) dengan Spacer
            const Spacer(flex: 2), // Beri 2 bagian ruang
            // 5. Teks Judul
            Text(
              content.title,
              style: TextStyle(
                color: kNeutral100,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),

            // 6. SizedBox kecil (10) tidak masalah
            const SizedBox(height: 10),

            // 7. Teks Deskripsi
            Text(
              content.description,
              style: TextStyle(
                color: kNeutral100,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            // 8. Beri sedikit ruang di bagian bawah
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
