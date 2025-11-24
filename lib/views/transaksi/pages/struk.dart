import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../data/models/transaksi/websocket_transaksi.dart';
import '../../home/cubit/balance_cubit.dart';
import '../../../core/utils/rupiah_text_field.dart';

class StrukPage extends StatefulWidget {
  final TransaksiResponse? transaksi;
  const StrukPage({super.key, this.transaksi});

  @override
  State<StrukPage> createState() => _StrukPageState();
}

class _StrukPageState extends State<StrukPage> {
  late TextEditingController _hargaController;
  TransaksiResponse? trx;

  String namaUser = "KONTER PULSA";
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _hargaController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) return;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    trx = args['transaksi'] as TransaksiResponse;

    final balanceState = context.read<BalanceCubit>().state;

    if (balanceState is BalanceLoaded) {
      namaUser = balanceState.data.namauser ?? "KONTER PULSA";
    } else {
      namaUser = "KONTER PULSA"; // fallback
    }

    _hargaController.text = trx?.harga.toString() ?? "0";

    _isInit = true;
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
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Text(
                      "=== $namaUser ===",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                        fontSize: kSize16,
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

                  // Input Harga
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: .center,
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
                          child: RupiahTextField(
                            controller: _hargaController,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (trx?.sn != null && trx!.sn!.trim().isNotEmpty)
                    _line("SN", trx?.sn ?? '-'),
                  const Divider(),
                  _line("OUTBOX", ''),
                  Text(
                    trx?.outbox ?? '-',
                    style: TextStyle(
                      fontFamily: "monospace",
                      fontSize: kSize14,
                    ),
                  ),
                  const Divider(),
                  Center(
                    child: Text(
                      "--- TERIMA KASIH ---",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: kSize14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Cetak & Share
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: .stretch,
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
                          style: TextStyle(color: kWhite, fontSize: kSize16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreen,
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
                          style: TextStyle(color: kWhite, fontSize: kSize16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SafeArea(
                  child: ElevatedButton(
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
                        fontSize: kSize18,
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
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

  // Line builder
  Widget _line(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: .start,
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
    TransaksiResponse trx,
    String namaUser,
    String hargaInput,
  ) async {
    final pdf = pw.Document();
    // parsing harga
    final parsedHarga = int.tryParse(
      hargaInput.replaceAll(RegExp(r'[^0-9]'), ''), // TODO (PAKE CURRENCYUTIL)
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
                if (trx.sn != null && trx.sn!.trim().isNotEmpty)
                  _pdfLine("SN", trx.sn),
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
                  trx.outbox ?? '-',
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

  @override
  void dispose() {
    _hargaController.dispose();
    super.dispose();
  }
}
