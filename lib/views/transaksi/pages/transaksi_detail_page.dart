import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/info_row.dart';
import 'package:intl/intl.dart';

import '../../../data/models/transaksi/websocket_transaksi.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        ModalRoute.of(context)!.settings.arguments as TransaksiResponse;

    log('${status.toJson()}');

    final int trxStatus = status.statusTrx;
    final Color statusColor = getStatusColor(trxStatus);
    final IconData statusIcon = getStatusIcon(trxStatus);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: statusColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Transaksi ${status.keterangan}',
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
                  backgroundColor: statusColor.withAlpha(40),
                  child: Icon(statusIcon, color: statusColor, size: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  status.keterangan, // langsung pakai getter
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
              color: kWhite,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    infoRow("Kode Transaksi", status.kode.toString()),
                    infoRow("Status", trxStatus.toString()),
                    infoRow("Produk", status.kodeProduk),
                    infoRow("Tujuan", status.tujuan),
                    infoRow(
                      "Waktu",
                      DateFormat('dd MMM yyyy, HH:mm').format(status.tglEntri),
                    ),
                    infoRow("Keterangan", status.keterangan),
                    const Divider(height: 32),
                    infoRow("Serial Number", status.sn ?? ''),
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
                      status.outbox ?? '',
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
}

// HELPER WARNA STATUS
Color getStatusColor(int statusTrx) {
  if ([0, 1, 2, 4].contains(statusTrx)) {
    return kOrange; // Kuning
  }
  if (statusTrx == 20) {
    return kGreen; // Hijau
  }
  if ([40, 43, 45, 47, 50, 52, 53, 55, 56, 58].contains(statusTrx)) {
    return kRed; // Merah
  }
  return kGrey; // Default
}

// HELPER ICON STATUS
IconData getStatusIcon(int statusTrx) {
  if ([0, 1, 2, 4].contains(statusTrx)) {
    return Icons.hourglass_bottom_rounded; // icon kuning
  }
  if (statusTrx == 20) {
    return Icons.check_circle_outline_rounded; // icon berhasil
  }
  return Icons.cancel_rounded; // icon gagal (merah)
}
