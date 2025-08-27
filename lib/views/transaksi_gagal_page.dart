import 'package:flutter/material.dart';
import 'package:xmlapp/views/riwayat_page.dart';

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
                  color: Colors.white.withOpacity(0.9),
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 80, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Transaksi Gagal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Silakan coba lagi atau hubungi admin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
