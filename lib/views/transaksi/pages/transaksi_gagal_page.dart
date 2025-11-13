import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../riwayat/pages/riwayat_page.dart';

class TransaksiGagalPage extends StatelessWidget {
  const TransaksiGagalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[700],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon X (gagal)
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kWhite.withAlpha(230),
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 80, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Transaksi Gagal",
                style: TextStyle(
                  color: kWhite,
                  fontSize: kSize24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Silakan coba lagi atau hubungi admin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: kWhite),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kWhite,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RiwayatTransaksiPage()),
                  );
                },
                child: const Text("Lihat Riwayat Transaksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
