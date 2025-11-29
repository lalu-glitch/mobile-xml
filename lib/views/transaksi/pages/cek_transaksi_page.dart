import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../data/models/transaksi/cek_transaksi_model.dart';
import '../../../data/models/transaksi/transaksi_helper_model.dart';
import '../../input_nomor/utils/base_state.dart';
import '../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../cubit/transaksi_omni/transaksi_omni_cubit.dart';
import '../cubit/transaksi_websocket/websocket_cektransaksi_cubit.dart';

class CekTransaksiPage extends StatefulWidget {
  const CekTransaksiPage({super.key});

  @override
  State<CekTransaksiPage> createState() => _CekTransaksiPageState();
}

class _CekTransaksiPageState extends BaseInput<CekTransaksiPage> {
  // simpen data sementara buat dipake di fungsi2 widget dibawahnya
  CekTransaksiModel? _cekTransaksiData;

  // Konstanta untuk kode flow agar tidak pakai magic number
  static const int _flowOmni = 9;

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  void _fetchTransactionData() {
    final helperCubit = context.read<TransaksiHelperCubit>();
    final flowCubit = context.read<FlowCubit>();
    final wsCubit = context.read<WebSocketCekTransaksiCubit>();

    // Reset state cubit sebelum dipakai
    wsCubit.reset();

    final transaksi = helperCubit.getData();
    final currentFlow = flowCubit.state?.flow;

    if (currentFlow == _flowOmni) {
      // Logic khusus OMNI
      final omniState = context.read<TransaksiOmniCubit>().state;
      final kodeOmni = omniState.kode ?? '';
      final kodeProduk = transaksi.kodeCek ?? ''; // omni pakai kodeCek

      wsCubit.cekTransaksi(kodeOmni, kodeProduk);
    } else {
      // Logic Normal
      final tujuan = transaksi.tujuan ?? '';
      final kodeProduk = transaksi.kodeProduk ?? '';
      wsCubit.cekTransaksi(tujuan, kodeProduk);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data transaksi sekali saja di build
    final transaksi = context.read<TransaksiHelperCubit>().getData();

    return buildPopScope(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: const Text(
            "Cek Produk Dan Bayar",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              BlocConsumer<
                WebSocketCekTransaksiCubit,
                WebSocketCekTransaksiState
              >(
                listener: (context, state) {
                  if (state is WebSocketCekTransaksiError) {
                    showErrorDialog(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is WebSocketCekTransaksiLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kOrange),
                    );
                  }
                  if (state is WebSocketCekTransaksiSuccess) {
                    // Simpan data ke variabel class agar bisa diakses handleNextButtonPress
                    _cekTransaksiData = state.data;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoCard(state.data, transaksi),
                          const SizedBox(height: 20),
                          _buildNextButton(),
                        ],
                      ),
                    );
                  }
                  if (state is WebSocketCekTransaksiError) {
                    return _buildStatusView(
                      context,
                      icon: Icons.receipt_long_rounded,
                      title: "Gagal Melakukan Pengecekan",
                      message: state.message,
                      color: kRed,
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }

  Widget _buildStatusView(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Visual Anchor (Icon with soft background)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 24),

            // 2. Clear Headline
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800], // Dark grey for readability
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),

            // 3. Supportive Subtext
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5, // Better line height for multi-line text
                color: kNeutral80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Card yang berisi detail informasi transaksi
  Widget _buildInfoCard(
    CekTransaksiModel data,
    TransaksiHelperModel transaksi,
  ) {
    return Card(
      color: kWhite,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._generateDetailRows(data),

            // Baris statis untuk Fee/Harga Produk dari client side
            if (_flowOmni != 9) ...[
              infoRow(
                "Fee",
                CurrencyUtil.formatCurrency(transaksi.productPrice),
                isTotal: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget Tombol Selanjutnya
  Widget _buildNextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: handleNextButtonPress,
      child: const Text(
        "Selanjutnya",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Membuat list widget baris informasi berdasarkan data respons server
  List<Widget> _generateDetailRows(CekTransaksiModel model) {
    final rows = <Widget>[];

    const fieldMapping = {
      "Nama Reseller": "nama_reseller",
      "Kode": "kode",
      "Tujuan": "tujuan",
      "Nama Pelanggan": "namapelanggan",
      "Total Tagihan": "rptagihan",
      "Fee": "harga_jual",
      "Admin": "admin",
      "Periode": "periode", //is this available in API?
    };

    fieldMapping.forEach((label, key) {
      final dynamic rawValue = model.data[key];
      // Hanya tampilkan jika data ada dan tidak kosong
      if (rawValue != null && rawValue.toString().trim().isNotEmpty) {
        String displayValue = rawValue.toString();

        // Format mata uang jika fieldnya tagihan atau admin
        if (key == "rptagihan" || key == "admin") {
          displayValue = CurrencyUtil.formatCurrency(
            CurrencyUtil.parseAmount(displayValue),
          );
        }

        rows.add(infoRow(label, displayValue));
        rows.add(const Divider(height: 20));
      }
    });

    return rows;
  }

  @override
  void handleNextButtonPress() {
    // Persiapan Data
    final transaksiHelper = context.read<TransaksiHelperCubit>();
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;

    final isOmni = flowState.flow == _flowOmni;
    final isLastPage = flowState.currentIndex == flowState.sequence.length - 1;

    // Ambil & Parsing Nominal
    // ---- TOTAL TAGIHAN ----
    final rawTagihan = _cekTransaksiData?.data["rptagihan"]?.toString();
    final tagihan = CurrencyUtil.parseAmount(rawTagihan);

    // ---- FEE ----
    int fee = 0;
    if (isOmni) {
      // OMNI pakai harga_jual dari WS
      final rawHargaJual = _cekTransaksiData?.data["harga_jual"]?.toString();
      fee = CurrencyUtil.parseAmount(rawHargaJual);
    } else {
      // NORMAL pakai productPrice sebagai fee
      fee = (transaksiHelper.getData().productPrice ?? 0.0).toInt();
    }

    // Simpan ke transaksi helper
    transaksiHelper.setFee(fee);
    transaksiHelper.setFinalTotalTagihan(tagihan);

    // Pengecekan Khusus (Hanya Normal Mode)
    // Jika kode produk diawali huruf 'C', batalkan flow dan kembali ke home.
    if (!isOmni) {
      final kodeProduk = transaksiHelper.getData().kodeProduk ?? "";
      if (kodeProduk.toUpperCase().startsWith('C')) {
        transaksiHelper.reset();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/homepage',
          (route) => false,
        );
        return;
      }
    }

    // Logika Navigasi (Unified Logic)
    if (isLastPage) {
      // Jika halaman terakhir flow, reset flow
      if (!isOmni) flowCubit.resetFlow();
      Navigator.pushNamed(context, '/konfirmasiPembayaran');
    } else {
      // Pindah ke halaman berikutnya dalam sequence
      _navigateToNextSequence(flowCubit);
    }
  }

  /// Logika untuk memajukan index halaman dan validasi rute
  void _navigateToNextSequence(FlowCubit flowCubit) {
    flowCubit.nextPage();
    final newState = flowCubit.state!;

    // Safety check index array
    if (newState.currentIndex < newState.sequence.length) {
      final nextPageName = newState.sequence[newState.currentIndex];
      final nextRoute = pageRoutes[nextPageName];

      if (nextRoute != null) {
        Navigator.pushNamed(context, nextRoute);
      } else {
        showErrorDialog(
          context,
          "Rute halaman '$nextPageName' tidak ditemukan.",
        );
      }
    } else {
      // Fallback jika index bablas
      flowCubit.resetFlow();
      showErrorDialog(context, "Terjadi kesalahan urutan halaman.");
    }
  }
}
