// struk_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/status_transaksi.dart';
import '../viewmodels/balance_viewmodel.dart';

class StrukPage extends StatelessWidget {
  final StatusTransaksi? transaksi; // bisa null di constructor
  const StrukPage({super.key, this.transaksi});

  @override
  Widget build(BuildContext context) {
    // ambil transaksi dari arguments jika null
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final StatusTransaksi trx = args['transaksi'] as StatusTransaksi;
    final balanceVM = Provider.of<BalanceViewModel>(context, listen: false);
    final String namaUser = balanceVM.userBalance?.namauser ?? "KONTER PULSA";
    final bool isSukses = trx.statusTrx == 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
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
                      "=== $namaUser ===", // dinamis dari state
                      style: const TextStyle(
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const Divider(),
                  _line("Kode", trx.kode.toString()),
                  _line("Produk", trx.kodeProduk),
                  _line("Tujuan", trx.tujuan),
                  _line(
                    "Waktu",
                    DateFormat('dd MMM yyyy, HH:mm').format(trx.tglEntri),
                  ),
                  _line("Status", trx.keterangan),
                  _line("Harga", trx.harga.toString()),
                  _line("SN", trx.sn),
                  const Divider(),
                  _line("OUTBOX", ''),
                  Text(
                    trx.outbox,
                    style: TextStyle(fontFamily: "monospace", fontSize: 14),
                  ),
                  const Divider(),
                  const Center(
                    child: Text(
                      "--- TERIMA KASIH ---",
                      style: TextStyle(fontFamily: "monospace", fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      await Printing.layoutPdf(
                        onLayout: (format) => _generatePdf(trx, namaUser),
                      );
                    },
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text(
                      "Print",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final pdfBytes = await _generatePdf(trx, namaUser);
                      final xfile = XFile.fromData(
                        pdfBytes,
                        mimeType: "application/pdf",
                        name: "struk_${trx.kode}.pdf",
                      );
                      await Share.shareXFiles([xfile]);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text(
                      "Share",
                      style: TextStyle(color: Colors.white),
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
          const Text(" : "), // titik dua konsisten, tidak ikut label
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

  Future<Uint8List> _generatePdf(StatusTransaksi trx, String namaUser) async {
    final pdf = pw.Document();
    final isSukses = trx.statusTrx == 20;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          100 * PdfPageFormat.mm, // lebar 100mm (sekitar 58mm printer thermal)
          double.infinity, // panjang menyesuaikan konten
        ),
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ), // biar ada jarak dari tepi
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header nama user / konter
                pw.Center(
                  child: pw.Text(
                    "=== $namaUser ===", // dinamis sesuai state
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

                // Detail transaksi
                _pdfLine("Kode", trx.kode.toString()),
                _pdfLine("Produk", trx.kodeProduk),
                _pdfLine("Tujuan", trx.tujuan),
                _pdfLine(
                  "Waktu",
                  DateFormat('dd MMM yyyy, HH:mm').format(trx.tglEntri),
                ),
                _pdfLine("Status", trx.keterangan),
                _pdfLine("Harga", trx.harga.toString()),

                if (trx.sn.isNotEmpty) _pdfLine("SN", trx.sn),

                pw.Divider(),

                // Outbox (pakai multi-line biar wrap kalau panjang)
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
                  textAlign: pw.TextAlign.left,
                  softWrap: true,
                ),

                pw.Divider(),
                pw.SizedBox(height: 4),

                // Footer
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

  /// Helper untuk membuat line label: value
  pw.Widget _pdfLine(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 80, // lebar tetap untuk label biar rata kanan
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
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
