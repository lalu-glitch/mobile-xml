import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class TransaksiDownlineTabPage extends StatelessWidget {
  const TransaksiDownlineTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ListView.builder efisien untuk menampilkan daftar yang panjang
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 8, // Jumlah item dalam daftar
        itemBuilder: (context, index) {
          // Setiap item dalam list adalah widget _TransactionCard
          return _TransactionCard();
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Column utama untuk menyusun semua elemen secara vertikal
          mainAxisSize: MainAxisSize.min, // Membuat Column sesuai ukuran konten
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Atas: ID, Nama, dan Status
            _buildTopSection(),
            const SizedBox(height: 12.0),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 12.0),
            // Bagian Bawah: Detail Upline, Stok, dan Transaksi
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  /// Widget untuk bagian atas kartu (ID, Nama, dan Status)
  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolom untuk ID dan Nama
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMS0795632',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kBlack,
              ),
            ),
            SizedBox(height: 4.0),
            Text('Yeni', style: TextStyle(fontSize: 14, color: kGrey)),
          ],
        ),
        // Badge Status "Aktif"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: kGreen.withAlpha(50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Aktif',
            style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// Widget untuk bagian bawah kartu (Detail Upline, Stok, Transaksi)
  Widget _buildBottomSection() {
    return Row(
      // Menggunakan Row dengan 2 Expanded agar terbagi sama rata
      children: [
        // Kolom Kiri: Upline dan Stok
        Expanded(
          child: Column(
            children: [
              _buildDetailRow('Upline', 'SMS0795632'),
              const SizedBox(height: 8.0),
              _buildDetailRow('Stok pulsa', '1.020.864'),
            ],
          ),
        ),
        const SizedBox(width: 16.0), // Spasi pemisah antara kolom
        // Kolom Kanan: Transaksi Sukses dan Gagal
        Expanded(
          child: Column(
            children: [
              _buildDetailRow('Trx sukses', '500'),
              const SizedBox(height: 8.0),
              _buildDetailRow('Trx gagal', '3'),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper widget untuk membuat baris detail (Label dan Value)
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: kGrey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
      ],
    );
  }
}
