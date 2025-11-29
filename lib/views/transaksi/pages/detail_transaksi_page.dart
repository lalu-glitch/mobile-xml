import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/custom_painter_helper.dart';
import '../../../data/models/transaksi/websocket_transaksi_model.dart';
import '../widgets/widget_transaksi_detail_row.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data jika argument null (Safety Dev)
    final args = ModalRoute.of(context)?.settings.arguments;
    final status = args is TransaksiResponse ? args : null;

    if (status == null) {
      return const Scaffold(body: Center(child: Text("Data Error")));
    }

    final int trxStatus = status.statusTrx;
    final Color statusColor = getStatusColor(trxStatus);
    final IconData statusIcon = getStatusIcon(trxStatus);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: kBlack),
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // 1. RECEIPT CARD SECTION
            ClipPath(
              clipper: InvertedCircleClipper(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header Icon (tanpa Lottie di sini lagi)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      status.keterangan,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM yyyy • HH:mm').format(status.tglEntri),
                      style: TextStyle(color: kNeutral60, fontSize: 12),
                    ),
                    const SizedBox(height: 32),
                    const DashedLineDivider(),
                    const SizedBox(height: 24),

                    // === DETAIL ROWS (sama seperti sebelumnya) ===
                    TransaksiDetailRow(
                      label: "Produk",
                      value: status.kodeProduk,
                    ),
                    TransaksiDetailRow(label: "Tujuan", value: status.tujuan),
                    TransaksiDetailRow(
                      label: "Kode Transaksi",
                      value: status.kode.toString(),
                      canCopy: true,
                    ),

                    if (status.sn != null && status.sn!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kNeutral20,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kNeutral20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Serial Number (SN)",
                              style: TextStyle(fontSize: 11, color: kGrey),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              status.sn!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Monospace',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (status.outbox != null && status.outbox!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const DashedLineDivider(),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Catatan / Pesan",
                          style: TextStyle(fontSize: 12, color: kNeutral80),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kYellow.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.outbox!,
                          style: TextStyle(
                            fontSize: 12,
                            color: kNeutral90,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 2. ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/struk',
                        arguments: {'transaksi': status},
                      );
                    },
                    icon: Icon(
                      Icons.print_rounded,
                      size: 18,
                      color: statusColor,
                    ),
                    label: Text("Cetak", style: TextStyle(color: statusColor)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: statusColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: kWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: kWhite,
                    ),
                    label: const Text(
                      "Selesai",
                      style: TextStyle(color: kWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 14, color: kNeutral50),
                const SizedBox(width: 6),
                Text(
                  "Transaksi Anda aman & terenkripsi",
                  style: TextStyle(color: kNeutral50, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(int statusTrx) {
  if ([0, 1, 2, 4].contains(statusTrx)) {
    return kOrange;
  }
  if (statusTrx == 20) {
    return kGreen;
  }
  if ([40, 43, 45, 47, 50, 52, 53, 55, 56, 58].contains(statusTrx)) {
    return kRed;
  }

  return kGrey;
}

IconData getStatusIcon(int statusTrx) {
  if ([0, 1, 2, 4].contains(statusTrx)) return Icons.hourglass_top_rounded;
  if (statusTrx == 20) return Icons.check_circle_rounded;
  return Icons.cancel_rounded;
}
