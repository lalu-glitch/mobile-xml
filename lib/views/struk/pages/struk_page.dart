import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/custom_painter_helper.dart';
import '../../../core/utils/rupiah_text_field.dart';
import '../../home/cubit/balance_cubit.dart';
import '../widgets/widget_struk_component.dart';
import '../widgets/widget_struk_pdf_generator.dart';

class StrukPage extends StatefulWidget {
  final dynamic transaksi;
  const StrukPage({super.key, this.transaksi});

  @override
  State<StrukPage> createState() => _StrukPageState();
}

class _StrukPageState extends State<StrukPage> {
  late TextEditingController _hargaController;
  dynamic trx;
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
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      trx = args['transaksi'];
    } else {
      trx = widget.transaksi;
    }

    final balanceState = context.read<BalanceCubit>().state;
    if (balanceState is BalanceLoaded) {
      namaUser = balanceState.data.namauser ?? "KONTER PULSA";
    }

    _hargaController.text = trx?.harga.toString() ?? "0";
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'Struk Transaksi',
          style: TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kBackground,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: kBlack),
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipPath(
              clipper:
                  ReceiptClipper(), // Menggunakan widget dari struk_components.dart
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header Toko
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kOrange.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront,
                        size: 32,
                        color: kOrange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      namaUser.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'dd MMM yyyy • HH:mm',
                      ).format(trx?.tglEntri ?? DateTime.now()),
                      style: TextStyle(color: kGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    const DashedLineDivider(),
                    const SizedBox(height: 20),
                    StrukItemRow("Tujuan", trx?.tujuan),
                    StrukItemRow("Produk", trx?.kodeProduk),
                    StrukItemRow("Harga Produk", (trx?.harga).toString()),
                    StrukItemRow("Kode Transaksi", trx?.kode.toString()),
                    if (trx?.sn != null &&
                        trx!.sn!.toString().trim().isNotEmpty)
                      StrukItemRow("SN / Ref", trx?.sn, isBold: true),

                    const SizedBox(height: 10),

                    // Status Badge
                    _buildStatusBadge(),
                    const SizedBox(height: 20),
                    const DashedLineDivider(),
                    const SizedBox(height: 20),

                    // Input Harga
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Total Bayar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: RupiahTextField(
                            controller: _hargaController,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Outbox Section
                    if (trx?.outbox != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kYellow.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kNeutral30),
                        ),
                        child: Text(
                          trx?.outbox ?? '-',
                          style: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 11,
                            color: kNeutral90,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Widget buat Status
  Widget _buildStatusBadge() {
    final isSuccess =
        trx?.keterangan?.toString().toLowerCase().contains('sukses') ?? true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSuccess ? kGreen.withAlpha(26) : kRed.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        trx?.keterangan ?? "PROSES",
        style: TextStyle(
          color: isSuccess ? kGreen : kRed,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: kWhite),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handlePrintOrShare(share: false),
                icon: const Icon(Icons.print_outlined),
                label: const Text("Cetak"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kOrange,
                  side: const BorderSide(color: kOrange),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handlePrintOrShare(share: true),
                icon: const Icon(Icons.share, color: kWhite),
                label: const Text("Share", style: TextStyle(color: kWhite)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePrintOrShare({required bool share}) async {
    // Memanggil class generator yang sudah dipisah
    final pdfBytes = await StrukPdfGenerator.generate(
      trx: trx!,
      namaUser: namaUser,
      hargaInput: _hargaController.text,
    );

    if (share) {
      final xfile = XFile.fromData(
        pdfBytes,
        mimeType: "application/pdf",
        name: "struk_${trx?.kode}.pdf",
      );
      await SharePlus.instance.share(ShareParams(files: [xfile]));
    } else {
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    }
  }

  @override
  void dispose() {
    _hargaController.dispose();
    super.dispose();
  }
}
