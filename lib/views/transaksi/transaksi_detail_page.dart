import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import '../../data/models/transaksi/status_transaksi.dart';
import 'package:intl/intl.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        ModalRoute.of(context)!.settings.arguments as StatusTransaksi;

    final bool isSuccess = status.statusTrx == 20;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: kOrange,
        title: Text(
          isSuccess ? "Transaksi Sukses!" : "Transaksi Gagal!",
          style: const TextStyle(color: kWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: kWhite,
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSuccess ? Colors.green[600] : Colors.red[600],
                boxShadow: [
                  BoxShadow(
                    color: (isSuccess ? Colors.green : kRed).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Icon(
                isSuccess ? Icons.check : Icons.close,
                color: kWhite,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isSuccess ? "Transaksi Berhasil!" : "Transaksi Gagal!",
              style: TextStyle(
                fontSize: Screen.kSize24,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green : kRed,
              ),
            ),
            const SizedBox(height: 24),

            // Card detail transaksi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Kode", status.kode.toString()),
                    _infoRow("Status", status.statusTrx.toString()),
                    _infoRow("Produk", status.kodeProduk),
                    _infoRow("Tujuan", status.tujuan),
                    _infoRow(
                      "Waktu",
                      DateFormat('dd MMM yyyy, HH:mm').format(status.tglEntri),
                    ),
                    _infoRow("Keterangan", status.keterangan),
                    const SizedBox(height: 10),

                    Container(
                      color: Colors.grey[300],
                      height: 10,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 10),
                    _infoRow("SN ", status.sn),
                    const Divider(height: 10),
                    Text(
                      "Outbox",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Screen.kSize16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(status.outbox),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey[300],
                      height: 10,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Selesai
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess
                          ? Colors.green[600]
                          : Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Selesai",
                      style: TextStyle(
                        fontSize: Screen.kSize18,
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Jarak antar tombol
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: Colors.orangeAccent.shade100,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/struk',
                        arguments: {'transaksi': status},
                      );
                    },
                    child: Text(
                      "Cetak Struk",
                      style: TextStyle(
                        fontSize: Screen.kSize16,
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
