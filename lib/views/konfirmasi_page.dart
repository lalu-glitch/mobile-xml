// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../core/utils/currency.dart';
import '../core/utils/error_dialog.dart';
import '../viewmodels/balance_viewmodel.dart';

class KonfirmasiPembayaranPage extends StatefulWidget {
  const KonfirmasiPembayaranPage({
    super.key,
    required String tujuan,
    required String kode_produk,
    required String namaProduk,
    required int total,
  });

  @override
  State<KonfirmasiPembayaranPage> createState() =>
      _KonfirmasiPembayaranPageState();
}

class _KonfirmasiPembayaranPageState extends State<KonfirmasiPembayaranPage> {
  late String tujuan;
  late String kode_produk;
  late String namaProduk;
  late double total;
  final logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    tujuan = args['tujuan'];
    kode_produk = args['kode_produk'];
    namaProduk = args['namaProduk'];
    total = (args['total'] as num).toDouble(); // <- aman untuk int/double
  }

  String _selectedMethod = "SALDO"; // Default pilihan
  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final saldo = balanceVM.userBalance?.saldo ?? 0;
    final eWallet = balanceVM.userBalance?.ewallet;
    final methods = [
      // generate dari eWallet list
      {
        "label": "SALDO",
        "secondary": CurrencyUtil.formatCurrency(saldo),
        "secondaryVal": saldo,
        "ewallet": "",
      },

      if (eWallet != null)
        for (var ew in eWallet)
          {
            "label": "${ew.nama}",
            "secondary": CurrencyUtil.formatCurrency(ew.saldoEwallet),
            "secondaryVal": ew.saldoEwallet,
            "ewallet": ew.kodeDompet,
          },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    _infoRow("Nomor Tujuan", tujuan),
                    const Divider(height: 24),
                    _infoRow("Kode Produk", kode_produk),
                    const Divider(height: 24),
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
            const SizedBox(height: 24),

            // === Metode Pembayaran ===
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "METODE PEMBAYARAN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: methods.map((method) {
                final isSelected =
                    _selectedMethod == (method["label"] as String? ?? '');

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _selectedMethod = (method["label"] as String? ?? '');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (method["label"] as String? ?? ''),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (method["secondary"] != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    (method["secondary"] as String? ?? ''),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Colors.orangeAccent[700]
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // === Tombol Bayar ===
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
                  if (_selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih metode pembayaran dulu"),
                      ),
                    );
                    return;
                  }
                  final selected = methods.firstWhere(
                    (m) => m["label"] == _selectedMethod,
                    orElse: () => {},
                  );

                  final selectedSaldo =
                      (selected["secondaryVal"] as num?)?.toDouble() ?? 0;

                  // logger.d("total: $total");
                  // logger.d("selectedSaldo: $selectedSaldo");

                  if (total > selectedSaldo) {
                    if (selectedSaldo <= 0) {
                      showErrorDialog(
                        context,
                        "Saldo ${_selectedMethod ?? ''} minus, hubungi CS / admin untuk bisa transaksi.",
                      );
                    } else {
                      showErrorDialog(
                        context,
                        "Saldo ${_selectedMethod ?? ''} tidak mencukupi untuk melakukan transaksi ini",
                      );
                    }
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/transaksiProses',
                      (route) => false,
                      arguments: {
                        'tujuan': tujuan, // ✔ Sama dengan yang dibaca
                        'kode_produk': kode_produk, // ✔ Sama dengan yang dibaca
                        'kode_dompet': selected?["ewallet"],
                      },
                    );
                  }
                },
                child: Text(
                  "SELANJUTNYA",
                  style: TextStyle(
                    fontSize: 16.sp,
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

  /// Widget helper untuk row informasi produk
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
              color: isTotal ? Colors.orangeAccent[700] : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
