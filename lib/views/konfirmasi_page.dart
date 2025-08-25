import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaksi_sukses_page.dart';

class KonfirmasiPembayaranPage extends StatelessWidget {
  final String nomorTujuan;
  final String kodeProduk;
  final String namaProduk;
  final double total;
  final double saldo;

  const KonfirmasiPembayaranPage({
    super.key,
    required this.nomorTujuan,
    required this.kodeProduk,
    required this.namaProduk,
    required this.total,
    required this.saldo,
  });

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
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Produk
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _infoRow("Nomor Tujuan", nomorTujuan),
                    const Divider(height: 24),
                    _infoRow("Kode Produk", kodeProduk),
                    const Divider(height: 24),
                    _infoRow("Nama Produk", namaProduk),
                    const Divider(height: 24),
                    _infoRow(
                      "Total Pembayaran",
                      formatCurrency(total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Metode Pembayaran
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "METODE PEMBAYARAN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SALDO",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(saldo),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.radio_button_checked,
                          color: Colors.orangeAccent[700],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Tombol Bayar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.orangeAccent.shade100,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TransaksiSuksesPage(sisaSaldo: saldo - total),
                    ),
                  );
                },
                child: const Text(
                  "SELESAIKAN PEMBAYARAN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk row info
  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? Colors.orangeAccent[700] : Colors.black,
          ),
        ),
      ],
    );
  }
}
