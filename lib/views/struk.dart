// struk_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaksi_riwayat.dart';

class StrukPage extends StatelessWidget {
  final RiwayatTransaksi transaksi;

  const StrukPage({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    // misal status 20 = sukses, selain itu gagal
    final isSukses = transaksi.status == 20;

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
                      "=== KONTER PULSA HAIYU ===",
                      style: const TextStyle(
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Jl. Raya Cilacap No.123",
                      style: const TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Divider(),
                  _line("KODE", transaksi.kode),
                  _line("Tanggal", transaksi.tglEntri.toString()),
                  _line("Status", isSukses ? "Sukses" : "Gagal"),
                  const Divider(),
                  _line("Nomor", transaksi.tujuan),
                  _line("Harga", "Rp ${transaksi.harga.toStringAsFixed(0)}"),
                  const Divider(),
                  Center(
                    child: Text(
                      isSukses ? "TRANSAKSI BERHASIL" : "TRANSAKSI GAGAL",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSukses ? Colors.black : Colors.red,
                      ),
                    ),
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
                        onLayout: (format) => _generatePdf(transaksi),
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
                      final pdfBytes = await _generatePdf(transaksi);
                      final xfile = XFile.fromData(
                        pdfBytes,
                        mimeType: "application/pdf",
                        name: "struk_${transaksi.kode}.pdf",
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

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label : $value",
        style: const TextStyle(fontFamily: "monospace", fontSize: 14),
      ),
    );
  }

  Future<Uint8List> _generatePdf(RiwayatTransaksi trx) async {
    final pdf = pw.Document();
    final isSukses = trx.status == 20;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "=== KONTER PULSA HAIYU ===",
                    style: pw.TextStyle(
                      font: pw.Font.courier(),
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    "Jl. Raya Cilacap No.123",
                    style: pw.TextStyle(font: pw.Font.courier(), fontSize: 12),
                  ),
                ),
                pw.Divider(),
                _pdfLine("ID TRX", trx.kode),
                _pdfLine("Tanggal", trx.tglEntri.toString()),
                _pdfLine("Status", isSukses ? "Sukses" : "Gagal"),
                pw.Divider(),
                _pdfLine("Nomor", trx.tujuan),
                _pdfLine("Harga", "Rp ${trx.harga.toStringAsFixed(0)}"),
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    isSukses ? "TRANSAKSI BERHASIL" : "TRANSAKSI GAGAL",
                    style: pw.TextStyle(
                      font: pw.Font.courier(),
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: isSukses ? PdfColors.black : PdfColors.red,
                    ),
                  ),
                ),
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    "--- TERIMA KASIH ---",
                    style: pw.TextStyle(font: pw.Font.courier(), fontSize: 14),
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

  pw.Widget _pdfLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        "$label : $value",
        style: pw.TextStyle(font: pw.Font.courier(), fontSize: 14),
      ),
    );
  }
}
