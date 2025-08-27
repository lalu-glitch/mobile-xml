import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/currency.dart';
import '../utils/error_dialog.dart';
import '../viewmodels/balance_viewmodel.dart';
import 'transaksi_proses_page.dart';

class KonfirmasiPembayaranPage extends StatefulWidget {
  final String nomorTujuan;
  final String kodeProduk;
  final String namaProduk;
  final double total;

  const KonfirmasiPembayaranPage({
    super.key,
    required this.nomorTujuan,
    required this.kodeProduk,
    required this.namaProduk,
    required this.total,
  });

  @override
  State<KonfirmasiPembayaranPage> createState() =>
      _KonfirmasiPembayaranPageState();
}

class _KonfirmasiPembayaranPageState extends State<KonfirmasiPembayaranPage> {
  String _selectedMethod = "SALDO"; // Default pilihan

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final saldo = balanceVM.userBalance?.saldo ?? 0;

    final methods = [
      {"label": "SALDO", "secondary": CurrencyUtil.formatCurrency(saldo)},
      {"label": "SPEEDCASH", "secondary": null},
      {"label": "NOBU", "secondary": null},
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
                    _infoRow("Nomor Tujuan", widget.nomorTujuan),
                    const Divider(height: 24),
                    _infoRow("Kode Produk", widget.kodeProduk),
                    const Divider(height: 24),
                    _infoRow("Nama Produk", widget.namaProduk),
                    const Divider(height: 24),
                    _infoRow(
                      "Total Pembayaran",
                      CurrencyUtil.formatCurrency(widget.total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // === Metode Pembayaran ===
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "METODE PEMBAYARAN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: methods.map((method) {
                final isSelected = _selectedMethod == method["label"];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _selectedMethod = method["label"]!;
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
                            method["label"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (method["secondary"] != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    method["secondary"]!,
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
                  if (_selectedMethod == "SALDO" && widget.total > saldo) {
                    showErrorDialog(
                      context,
                      "Saldo tidak mencukupi untuk melakukan transaksi ini",
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransaksiProsesPage(
                          nomorTujuan: widget.nomorTujuan,
                          kodeProduk: widget.kodeProduk,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "SELANJUTNYA",
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

  /// Widget helper untuk row informasi produk
  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? Colors.orangeAccent[700] : Colors.black,
          ),
        ),
      ],
    );
  }
}
