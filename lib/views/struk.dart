import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class StrukPage extends StatelessWidget {
  final Map<String, dynamic> transaksi;

  const StrukPage({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final isSukses = transaksi["status"] == "Sukses";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Struk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(
          color: Colors.white, // 🔹 arrow (leading/back) jadi putih
        ),
      ),
      body: Column(
        children: [
          // konten struk
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "=== KONTER PULSA ABC ===",
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
                    const SizedBox(height: 8),
                    const Divider(),
                    _line("ID TRX", transaksi["id"] ?? "INV123456"),
                    _line("Tanggal", transaksi["tanggal"] ?? "-"),
                    _line("Status", transaksi["status"] ?? "-"),
                    const Divider(),
                    _line("Produk", transaksi["produk"] ?? "-"),
                    _line("Nomor", transaksi["nomor"] ?? "-"),
                    _line("Harga", "Rp ${transaksi["total"] ?? 0}"),
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
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        "--- TERIMA KASIH ---",
                        style: const TextStyle(
                          fontFamily: "monospace",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // tombol print & share
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

                      // langsung share sebagai file PDF
                      final xfile = XFile.fromData(
                        pdfBytes,
                        mimeType: "application/pdf",
                        name: "struk_${transaksi["id"] ?? "trx"}.pdf",
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

  /// Generate PDF struk
  Future<Uint8List> _generatePdf(Map<String, dynamic> trx) async {
    final pdf = pw.Document();
    final isSukses = trx["status"] == "Sukses";

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
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
                pw.SizedBox(height: 8),
                pw.Divider(),
                _pdfLine("ID TRX", trx["id"] ?? "INV123456"),
                _pdfLine("Tanggal", trx["tanggal"] ?? "-"),
                _pdfLine("Status", trx["status"] ?? "-"),
                pw.Divider(),
                _pdfLine("Produk", trx["produk"] ?? "-"),
                _pdfLine("Nomor", trx["nomor"] ?? "-"),
                _pdfLine("Harga", "Rp ${trx["total"] ?? 0}"),
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
                pw.SizedBox(height: 32),
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
