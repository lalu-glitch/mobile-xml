import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../data/models/transaksi/cek_transaksi.dart';
import '../../../data/models/transaksi/transaksi_helper.dart';
import '../../input_nomor/utils/base_state.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../cubit/transaksi_omni/transaksi_omni_cubit.dart';
import '../cubit/transaksi_websocket/websocket_cektransaksi_cubit.dart';

class CekTransaksiPage extends StatefulWidget {
  const CekTransaksiPage({super.key});

  @override
  State<CekTransaksiPage> createState() => _CekTransaksiPageState();
}

class _CekTransaksiPageState extends BaseInput<CekTransaksiPage> {
  // Variabel local untuk menyimpan data sementara agar mudah diakses
  CekTransaksiModel? _cekTransaksiData;

  // Konstanta untuk kode flow agar tidak pakai magic number
  static const int _flowOmni = 9;

  @override
  void initState() {
    super.initState();
    // Kita pindahkan logika inisialisasi yang rumit ke fungsi terpisah
    _fetchTransactionData();
  }

  /// Memulai proses pengecekan transaksi ke server via WebSocket
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
      final kodeProduk = transaksi.kodeCek ?? ''; // Di omni pakai kodeCek

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
              BlocBuilder<
                WebSocketCekTransaksiCubit,
                WebSocketCekTransaksiState
              >(
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
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              ),
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
    // 1. Persiapan Data
    final transaksiHelper = context.read<TransaksiHelperCubit>();
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;

    final isOmni = flowState.flow == _flowOmni;
    final isLastPage = flowState.currentIndex == flowState.sequence.length - 1;

    // 2. Ambil & Parsing Nominal
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

    // 4. Pengecekan Khusus (Hanya Normal Mode)
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

    // 5. Logika Navigasi (Unified Logic)
    if (isLastPage) {
      // Jika halaman terakhir flow, reset flow (kecuali OMNI mungkin butuh logic beda,
      // tapi biasanya reset itu aman) dan masuk konfirmasi.
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
