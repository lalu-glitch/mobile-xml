import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmlapp/views/riwayat_page.dart';

class TransaksiSuksesPage extends StatelessWidget {
  final double sisaSaldo;
  const TransaksiSuksesPage({super.key, required this.sisaSaldo});

  String formatCurrency(double value) {
    final format = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                "Transaksi Sukses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Terima kasih telah menjadi mitra terpercaya kami, saldo Anda tersisa ${formatCurrency(sisaSaldo)}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
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
                  // Navigasi ke halaman sukses
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiwayatTransaksiPage()),
                  );
                },
                child: const Text("Buka Riwayat Transaksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
