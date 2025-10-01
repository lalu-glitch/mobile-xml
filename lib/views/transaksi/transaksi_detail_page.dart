import 'package:flutter/material.dart';

import '../../data/models/transaksi/status_transaksi.dart';
import 'package:intl/intl.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        ModalRoute.of(context)!.settings.arguments as StatusTransaksiModel;

    final bool isSuccess = status.statusTrx == 20;

    final Color statusColor = isSuccess ? Colors.green : Colors.red;
    final IconData statusIcon = isSuccess ? Icons.check_circle : Icons.cancel;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: statusColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isSuccess ? "Transaksi Sukses" : "Transaksi Gagal",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Status
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: statusColor.withOpacity(0.15),
                  child: Icon(statusIcon, color: statusColor, size: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? "Transaksi Berhasil" : "Transaksi Gagal",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Card Detail
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoRow("Kode Transaksi", status.kode.toString()),
                    _infoRow("Status", status.statusTrx.toString()),
                    _infoRow("Produk", status.kodeProduk),
                    _infoRow("Tujuan", status.tujuan),
                    _infoRow(
                      "Waktu",
                      DateFormat('dd MMM yyyy, HH:mm').format(status.tglEntri),
                    ),
                    _infoRow("Keterangan", status.keterangan),
                    const Divider(height: 32),
                    _infoRow("Serial Number", status.sn),
                    const Divider(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pesan Outbox",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      status.outbox,
                      style: TextStyle(color: Colors.grey[700], height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Action
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Selesai",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/struk',
                        arguments: {'transaksi': status},
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: statusColor, width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      "Cetak Struk",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
