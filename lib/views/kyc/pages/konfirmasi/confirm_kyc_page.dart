import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KonfirmasiKYCPage extends StatelessWidget {
  const KonfirmasiKYCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const Spacer(),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(shape: .circle),
                child: const Icon(
                  Icons.verified_outlined,
                  size: 100,
                  color: kGreen,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'PENGAJUAN BERHASIL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: .bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                'Permintaan verifikasi akunmu sudah kami terima.\nSilakan menunggu, pemberitahuan selanjutnya akan\ndikirim setelah proses selesai.',
                style: TextStyle(fontSize: 14, color: kNeutral60, height: 1.5),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: kNeutral60),
                child: const Text(
                  'Butuh bantuan?',
                  style: TextStyle(fontSize: 14, fontWeight: .w500),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: .circular(16)),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 16, fontWeight: .w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
