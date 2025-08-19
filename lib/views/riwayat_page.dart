import 'package:flutter/material.dart';

import 'struk.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  final List<Map<String, dynamic>> riwayat = [
    {
      "nomor": "085643085743",
      "produk": "Indosat Reguler 10K",
      "total": 10500,
      "status": "Sukses",
      "tanggal": "19-08-2025 10:25",
    },
    {
      "nomor": "081234567890",
      "produk": "Indosat Reguler 50K",
      "total": 50100,
      "status": "Sukses",
      "tanggal": "18-08-2025 15:10",
    },
    {
      "nomor": "087654321098",
      "produk": "Indosat Reguler 20K",
      "total": 20600,
      "status": "Gagal",
      "tanggal": "17-08-2025 09:45",
    },
  ];

  RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: riwayat.length,
        itemBuilder: (context, index) {
          final trx = riwayat[index];
          final isSukses = trx["status"] == "Sukses";
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: Text(
                trx["produk"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nomor: ${trx["nomor"]}"),
                  Text("Tanggal: ${trx["tanggal"]}"),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rp ${trx["total"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trx["status"],
                    style: TextStyle(
                      color: isSukses ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StrukPage(transaksi: trx)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
