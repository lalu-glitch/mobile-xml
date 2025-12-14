import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../data_diri/isi_data_diri_page.dart';
import 'selfie_ktp_onboarding_page.dart';

class KTPSelfieVerifyPage extends StatelessWidget {
  final String imagePath;

  const KTPSelfieVerifyPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Verifikasi KTP',
          style: TextStyle(color: kBlack, fontWeight: .bold),
        ),
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBlack),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FotoSelfieKTPOnboardingPage(),
            ),
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
                      style: TextStyle(fontSize: 16, color: kNeutral50),
                    ),
                    const SizedBox(height: 24),

                    // Container untuk menampilkan foto KTP
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: Border.all(color: kNeutral40),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withAlpha(26),
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
                        builder: (context) => FotoSelfieKTPOnboardingPage(),
                      ),
                    ), // Foto Ulang
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: kOrange),
                      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    ),
                    child: const Text(
                      "Foto Ulang",
                      style: TextStyle(color: kOrange, fontWeight: .bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ///TODO [UPLOAD]
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IsiDataDiriPage(isConfirm: true),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Gunakan Foto",
                      style: TextStyle(color: kWhite, fontWeight: .bold),
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
