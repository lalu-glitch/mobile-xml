import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/transaksi/transaksi_helper_model.dart';

class InputNomorPage extends StatefulWidget {
  const InputNomorPage({super.key});

  @override
  State<InputNomorPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends State<InputNomorPage> {
  final TextEditingController _nomorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final transaksi = args['transaksi'] as TransaksiModel;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Input Nomor Tujuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6D00),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Masukkan Nomor Tujuan"),
            const SizedBox(height: 8),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: "Input Nomor Tujuan",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.contact_page),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Hanya contoh aksi sederhana
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Nomor: ${_nomorController.text}")),
                // );
                final trxBaru = transaksi.copyWith(
                  tujuan: _nomorController.text,
                );
                Navigator.pushNamed(
                  context,
                  '/inputNomorMid',
                  arguments: {'transaksi': trxBaru},
                );
                print('Terkirim : $trxBaru');
              },
              child: const Text(
                "Selanjutnya",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text('Tujuan: ${transaksi.tujuan}'),
            Text('Kode Produk: ${transaksi.kodeProduk}'),
            Text('Nama Produk: ${transaksi.namaProduk}'),
            Text('Total: ${transaksi.total}'),
          ],
        ),
      ),
    );
  }
}
