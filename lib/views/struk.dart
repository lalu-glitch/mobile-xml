// struk_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../core/helper/constant_finals.dart';

import '../core/helper/currency.dart';
import '../data/models/transaksi/status_transaksi.dart';
import '../viewmodels/balance_viewmodel.dart';

class StrukPage extends StatefulWidget {
  final StatusTransaksi? transaksi;
  const StrukPage({super.key, this.transaksi});

  @override
  State<StrukPage> createState() => _StrukPageState();
}

class _StrukPageState extends State<StrukPage> {
  late TextEditingController _hargaController;
  StatusTransaksi? trx;
  String namaUser = "KONTER PULSA";
  bool _isInit = false; // biar cuma sekali eksekusi

  @override
  void initState() {
    super.initState();
    _hargaController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      trx = args['transaksi'] as StatusTransaksi;

      final balanceVM = Provider.of<BalanceViewModel>(context, listen: false);
      namaUser = balanceVM.userBalance?.namauser ?? "KONTER PULSA";

      // set default harga
      _hargaController.text = trx?.harga.toString() ?? "0";

      _isInit = true; // biar gak dipanggil berkali2
    }
  }

  @override
  void dispose() {
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "=== $namaUser ===",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                        fontSize: Screen.kSize16,
                      ),
                    ),
                  ),
                  const Divider(),
                  _line("Kode", trx?.kode.toString()),
                  _line("Produk", trx?.kodeProduk),
                  _line("Tujuan", trx?.tujuan),
                  _line(
                    "Waktu",
                    DateFormat('dd MMM yyyy, HH:mm').format(trx!.tglEntri),
                  ),
                  _line("Status", trx?.keterangan),

                  // Kolom Harga pakai TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text(
                            "Harga",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: "monospace",
                            ),
                          ),
                        ),
                        const Text(" : "),
                        Expanded(
                          child: TextField(
                            controller: _hargaController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontFamily: "monospace",
                              color: Colors.black87,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (trx!.sn.isNotEmpty) _line("SN", trx?.sn),
                  const Divider(),
                  _line("OUTBOX", ''),
                  Text(
                    trx!.outbox,
                    style: TextStyle(
                      fontFamily: "monospace",
                      fontSize: Screen.kSize14,
                    ),
                  ),
                  const Divider(),
                  Center(
                    child: Text(
                      "--- TERIMA KASIH ---",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: Screen.kSize14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () async {
                          final pdfBytes = await _generatePdf(
                            trx!,
                            namaUser,
                            _hargaController.text,
                          );
                          await Printing.layoutPdf(
                            onLayout: (format) async => pdfBytes,
                          );
                        },
                        icon: const Icon(Icons.print, color: kWhite),
                        label: Text(
                          "Cetak",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: Screen.kSize16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () async {
                          final pdfBytes = await _generatePdf(
                            trx!,
                            namaUser,
                            _hargaController.text,
                          );
                          final xfile = XFile.fromData(
                            pdfBytes,
                            mimeType: "application/pdf",
                            name: "struk_${trx?.kode}.pdf",
                          );
                          await Share.shareXFiles([xfile]);
                        },
                        icon: const Icon(Icons.share, color: kWhite),
                        label: Text(
                          "Share",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: Screen.kSize16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String? value) {
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
                fontFamily: "monospace",
              ),
            ),
          ),
          const Text(" : "),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: "monospace",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PDF generator menerima harga input
  Future<Uint8List> _generatePdf(
    StatusTransaksi trx,
    String namaUser,
    String hargaInput,
  ) async {
    final pdf = pw.Document();
    // parsing harga
    final parsedHarga = int.tryParse(
      hargaInput.replaceAll(RegExp(r'[^0-9]'), ''), // buang karakter non-digit
    );
    final hargaFormatted = CurrencyUtil.formatCurrency(parsedHarga as num?);

    // kalau gagal parsing, fallback ke trx.harga
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(100 * PdfPageFormat.mm, double.infinity),
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "=== $namaUser ===",
                    style: pw.TextStyle(
                      font: pw.Font.courier(),
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                _pdfLine("Kode", trx.kode.toString()),
                _pdfLine("Produk", trx.kodeProduk),
                _pdfLine("Tujuan", trx.tujuan),
                _pdfLine(
                  "Waktu",
                  DateFormat('dd MMM yyyy, HH:mm').format(trx.tglEntri),
                ),
                _pdfLine("Status", trx.keterangan),
                _pdfLine("Harga", hargaFormatted), // <- ambil dari TextField
                if (trx.sn.isNotEmpty) _pdfLine("SN", trx.sn),
                pw.Divider(),
                pw.Text(
                  "OUTBOX:",
                  style: pw.TextStyle(
                    font: pw.Font.courier(),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  trx.outbox,
                  style: pw.TextStyle(font: pw.Font.courier(), fontSize: 12),
                ),
                pw.Divider(),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(
                    "--- TERIMA KASIH ---",
                    style: pw.TextStyle(
                      font: pw.Font.courier(),
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfLine(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                font: pw.Font.courier(),
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              ": ${value ?? '-'}",
              style: pw.TextStyle(font: pw.Font.courier(), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
