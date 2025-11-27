import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/helper/currency.dart';

class StrukPdfGenerator {
  /// Fungsi utama untuk generate bytes PDF
  static Future<Uint8List> generate({
    required dynamic trx,
    required String namaUser,
    required String hargaInput,
  }) async {
    final pdf = pw.Document();

    // Logic parsing harga
    final parsedHarga = CurrencyUtil.parseAmount(hargaInput);
    final hargaFormatted = CurrencyUtil.formatCurrency(parsedHarga);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(58 * PdfPageFormat.mm, double.infinity),
        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  namaUser,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              _buildPdfRow(
                "Waktu",
                DateFormat('dd/MM/yy HH:mm').format(trx.tglEntri),
              ),
              _buildPdfRow("Kode", trx.kode.toString()),
              _buildPdfRow("Produk", trx.kodeProduk),
              _buildPdfRow("Tujuan", trx.tujuan),
              if (trx.sn != null && trx.sn.toString().isNotEmpty)
                _buildPdfRow("SN", trx.sn),
              pw.SizedBox(height: 5),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "TOTAL",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    hargaFormatted,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "Terima Kasih",
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Helper row khusus untuk PDF (Private method)
  static pw.Widget _buildPdfRow(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Flexible(
            child: pw.Text(
              value ?? '-',
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
