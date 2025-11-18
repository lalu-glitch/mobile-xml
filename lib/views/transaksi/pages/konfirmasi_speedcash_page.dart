import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../input_transaksi/utils/transaksi_cubit.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/konfirmasi_transaksi_speedcash_cubit.dart';
import '../cubit/pembayaran_transaksi_speedcash_cubit.dart';

class KonfirmasiSpeedcashPage extends StatelessWidget {
  const KonfirmasiSpeedcashPage({super.key});

  double _getTotalTransaksi(dynamic transaksi) {
    final double baseTotal = transaksi.total ?? 0;
    if (transaksi.isBebasNominal == 1) {
      final int nominalTambahan = transaksi.bebasNominalValue ?? 0;
      final total = baseTotal + nominalTambahan;
      return total;
    }
    return baseTotal;
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    final dataAkun = context.read<InfoAkunCubit>().state;
    final String kodeReseller = (dataAkun is InfoAkunLoaded)
        ? dataAkun.data.data.kodeReseller
        : '';

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('Konfirmasi Speedcash', style: TextStyle(color: kWhite)),
        backgroundColor: kBlue,
        iconTheme: IconThemeData(color: kWhite),
      ),
      body: MultiBlocListener(
        listeners: [
          // Listener untuk hasil konfirmasi -> panggil pembayaran
          BlocListener<
            KonfirmasiTransaksiSpeedcashCubit,
            KonfirmasiTransaksiSpeedcashState
          >(
            listener: (context, state) {
              if (state is KonfirmasiTransaksiSpeedcashSuccess) {
                // Ambil originalPartnerReferenceNo dari response
                final resp = state.data;
                final originalRef = resp.originalPartnerReferenceNo;
                context
                    .read<PembayaranTransaksiSpeedcashCubit>()
                    .pembayaranTransaksiSpeedcash(kodeReseller, originalRef);
              } else if (state is KonfirmasiTransaksiSpeedcashError) {
                showErrorDialog(context, state.message);
              }
            },
          ),

          // Listener untuk hasil pembayaran -> navigasi ke webview
          BlocListener<
            PembayaranTransaksiSpeedcashCubit,
            PembayaranTransaksiSpeedcashState
          >(
            listener: (context, state) {
              if (state is PembayaranTransaksiSpeedcashSuccess) {
                final url = state.data.url;
                Navigator.pushNamed(
                  context,
                  '/webView',
                  arguments: {'url': url, 'title': 'Bayar Speedcash'},
                );
              } else if (state is PembayaranTransaksiSpeedcashError) {
                showErrorDialog(context, state.message);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInfoCard(transaksi),
              const Spacer(),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(context, transaksi, kodeReseller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    dynamic transaksi,
    String kodeReseller,
  ) {
    // Ambil state kedua cubit untuk menentukan loading/disable button:
    final konfirmasiState = context
        .watch<KonfirmasiTransaksiSpeedcashCubit>()
        .state;
    final pembayaranState = context
        .watch<PembayaranTransaksiSpeedcashCubit>()
        .state;

    final bool isLoading =
        konfirmasiState is KonfirmasiTransaksiSpeedcashLoading ||
        pembayaranState is PembayaranTransaksiSpeedcashLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              // panggil konfirmasi. Pastikan method konfirmasi mengembalikan data originalPartnerReferenceNo
              context
                  .read<KonfirmasiTransaksiSpeedcashCubit>()
                  .konfirmasiTransaksiSpeedcash(
                    kodeReseller,
                    transaksi.kodeProduk!,
                    transaksi.tujuan!,
                    qty: 0,
                    endUser: '',
                  );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: kBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        shadowColor: Colors.blueAccent.shade100,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: kWhite, strokeWidth: 2),
            )
          : Text(
              "Selanjutnya",
              style: TextStyle(
                fontSize: kSize16,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
    );
  }

  /// Card informasi transaksi
  Widget _buildInfoCard(dynamic transaksi) {
    final totalTransaksi = _getTotalTransaksi(transaksi);
    return Card(
      color: kWhite,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            infoRow("Nomor Tujuan", transaksi.tujuan ?? ''),
            const Divider(height: 24),
            infoRow("Kode Produk", transaksi.kodeProduk ?? ''),
            const Divider(height: 24),
            infoRow("Nama Produk", transaksi.namaProduk ?? ''),
            const Divider(height: 24),
            infoRow(
              "Total Pembayaran",
              CurrencyUtil.formatCurrency(totalTransaksi),
              isTotal: true,
              color: kBlue,
            ),
          ],
        ),
      ),
    );
  }
}
