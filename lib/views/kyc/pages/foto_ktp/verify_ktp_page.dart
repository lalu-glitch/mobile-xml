import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../selfie_ktp/selfie_ktp_onboarding_page.dart';
import 'foto_ktp_onboarding_page.dart';

class KTPVerifyPage extends StatelessWidget {
  final String imagePath;

  const KTPVerifyPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Verifikasi KTP',
          style: TextStyle(color: Colors.black, fontWeight: .bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FotoKTPOnboardingPage()),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    const Text(
                      "Pastikan foto KTP terlihat jelas",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    // Container untuk menampilkan foto KTP
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: Border.all(color: kNeutral30),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withAlpha(25),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: .circular(12),
                        // Menampilkan gambar dari File System
                        child: Image.file(File(imagePath), fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Aksi Bawah
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FotoKTPOnboardingPage(),
                      ),
                    ), // Foto Ulang
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFFE7F04)),
                      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    ),
                    child: const Text(
                      "Foto Ulang",
                      style: TextStyle(
                        color: Color(0xFFFE7F04),
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FotoSelfieKTPOnboardingPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFE7F04),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Gunakan Foto",
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
