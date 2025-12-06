import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../data/models/transaksi/transaksi_helper_model.dart';
import '../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/transaksi_speedcash/konfirmasi_transaksi_speedcash_cubit.dart';
import '../cubit/transaksi_speedcash/pembayaran_transaksi_speedcash_cubit.dart';

class KonfirmasiSpeedcashPage extends StatelessWidget {
  const KonfirmasiSpeedcashPage({super.key});

  double _getTotalTransaksi(TransaksiHelperModel transaksi) {
    // Ambil nilai dasar dengan default 0.0 agar aman dari null
    final double finalTotal = transaksi.finalTotal ?? 0.0;
    final double fee = transaksi.fee ?? 0.0;
    final double productPrice = transaksi.productPrice ?? 0.0;
    final double bebasNominal = transaksi.bebasNominalValue ?? 0.0;

    // Cek Tagihan
    if (finalTotal > 0) {
      return finalTotal + fee;
    }
    // Cek Bebas Nominal
    if (transaksi.isBebasNominal) {
      return bebasNominal;
    }
    // Default
    return productPrice;
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
          // Listener untuk hasil konfirmasi terus panggil pembayaran
          BlocListener<
            KonfirmasiTransaksiSpeedcashCubit,
            KonfirmasiTransaksiSpeedcashState
          >(
            listener: (context, state) {
              if (state is KonfirmasiTransaksiSpeedcashSuccess) {
                final originalRef = state.data.originalPartnerReferenceNo;
                context
                    .read<PembayaranTransaksiSpeedcashCubit>()
                    .pembayaranTransaksiSpeedcash(kodeReseller, originalRef);
              } else if (state is KonfirmasiTransaksiSpeedcashError) {
                showErrorDialog(context, state.message);
              }
            },
          ),

          // Listener untuk hasil pembayaran terus navigasi ke webview
          BlocListener<
            PembayaranTransaksiSpeedcashCubit,
            PembayaranTransaksiSpeedcashState
          >(
            listener: (context, state) {
              if (state is PembayaranTransaksiSpeedcashSuccess) {
                final url = state.data.url;
                Navigator.pushNamed(
                  context,
                  '/webviewSpeedcash',
                  arguments: {'url': url, 'title': 'Bayar Speedcash'},
                );
              } else if (state is PembayaranTransaksiSpeedcashError) {
                showErrorDialog(context, state.message);
              }
            },
          ),
        ],
        child: Padding(
          padding: const .all(16),
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
    TransaksiHelperModel transaksi,
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
                    qty: transaksi.isBebasNominal
                        ? (transaksi.bebasNominalValue)!.toInt()
                        : 0,
                    endUser: transaksi.isEndUser ? transaksi.endUserValue! : '',
                    subProduk: '',

                    ///TODO
                    hargaSubProduk: 0,

                    ///TODO
                  );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: kBlue,
        padding: const .symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
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
                fontWeight: .w600,
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
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: Padding(
        padding: const .all(16.0),
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
