import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/error_dialog.dart';

class InputNomorTujuanPage extends StatefulWidget {
  const InputNomorTujuanPage({
    super.key,
    required String kode_produk,
    required String namaProduk,
    required String total,
  });

  @override
  State<InputNomorTujuanPage> createState() => _InputNomorTujuanPageState();
}

class _InputNomorTujuanPageState extends State<InputNomorTujuanPage> {
  final TextEditingController _nomorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String kodeProduk = args['kode_produk'];
    final String namaProduk = args['namaProduk'];
    final double total = args['total'];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Input Nomor Tujuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Produk: ${namaProduk}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Total: ${total}"),
            const SizedBox(height: 20),
            const Text("Masukkan Nomor Tujuan"),
            const SizedBox(height: 8),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: "0812xxxxxxx",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.contact_page),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_nomorController.text.isEmpty) {
                  showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
                  return;
                }

                Navigator.pushNamed(
                  context,
                  '/konfirmasiPembayaran',
                  arguments: {
                    'tujuan': _nomorController.text,
                    'kode_produk': kodeProduk,
                    'namaProduk': namaProduk,
                    'total': total,
                  },
                );
              },
              child: const Text(
                "Selanjutnya",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
