import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant_finals.dart';
import 'package:xmlapp/core/utils/currency.dart';

import '../core/utils/error_dialog.dart';

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
          style: TextStyle(color: kWhite),
        ),
        backgroundColor: const Color(0xFFFF6D00),
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Info Produk ===
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _infoRow("Nama Produk", namaProduk),
                        const Divider(height: 24),
                        _infoRow(
                          "Total Pembayaran",
                          CurrencyUtil.formatCurrency(total),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                backgroundColor: kOrange,
                foregroundColor: kWhite,
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

  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Maksimal 2 baris, ubah jika mau multi-line
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16.sp : 14.sp,
              color: isTotal ? kOrange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
