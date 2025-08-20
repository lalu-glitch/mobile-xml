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
        title: Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(
          color: Colors.white, // 🔹 arrow (leading/back) jadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info atas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nomor Tujuan",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      nomorTujuan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "Kode Produk",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      kodeProduk,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "Nama Produk",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      namaProduk,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Pembayaran",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      formatCurrency(total),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Metode Pembayaran
            const Text(
              "METODE PEMBAYARAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "SALDO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(formatCurrency(saldo)),
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
            const Spacer(),

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigasi ke halaman sukses
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
}
