import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import 'package:xmlapp/views/settings/cubit/info_akun/info_akun_cubit.dart';

import '../../../core/helper/currency.dart';
import '../../../core/utils/info_row.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../cubit/konfirmasi_transaksi_speedcash_cubit.dart';

class KonfirmasiSpeedcashPage extends StatefulWidget {
  const KonfirmasiSpeedcashPage({super.key});

  @override
  State<KonfirmasiSpeedcashPage> createState() =>
      _KonfirmasiSpeedcashPageState();
}

class _KonfirmasiSpeedcashPageState extends State<KonfirmasiSpeedcashPage> {
  double getTotalTransaksi(dynamic transaksi) {
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
    final String kodeReseller;
    final dataAkun = context.read<InfoAkunCubit>().state;

    if (dataAkun is InfoAkunLoaded) {
      kodeReseller = dataAkun.data.data.kodeReseller;
    } else {
      kodeReseller = '';
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('Konfirmasi Speedcash', style: TextStyle(color: kWhite)),
        backgroundColor: kBlue,
        iconTheme: IconThemeData(color: kWhite),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            buildInfoCard(transaksi),
            const Spacer(),
            buildPayButton(
              transaksi,
              kodeReseller,
              transaksi.kodeProduk!,
              transaksi.tujuan!,
            ),
          ],
        ),
      ),
    );
  }

  /// Card informasi transaksi
  Widget buildInfoCard(dynamic transaksi) {
    final totalTransaksi = getTotalTransaksi(transaksi);
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

  Widget buildPayButton(
    dynamic transaksi,
    String kodeReseller,
    String kodeProduk,
    String tujuan, {
    int qty = 0,
    String endUser = '',
  }) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context
                .read<KonfirmasiTransaksiSpeedcashCubit>()
                .konfirmasiTransaksiSpeedcash(kodeReseller, kodeProduk, tujuan);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            shadowColor: Colors.blueAccent.shade100,
          ),
          child: Text(
            "Selanjutnya",
            style: TextStyle(
              fontSize: kSize16,
              fontWeight: FontWeight.w600,
              color: kWhite,
            ),
          ),
        ),
      ),
    );
  }
}
