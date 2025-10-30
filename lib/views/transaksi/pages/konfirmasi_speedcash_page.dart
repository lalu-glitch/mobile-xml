import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

import '../../../core/helper/currency.dart';
import '../../../core/utils/info_row.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';

class KonfirmasiSpeedcashPage extends StatelessWidget {
  const KonfirmasiSpeedcashPage({super.key});

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
            buildPayButton(transaksi),
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

  Widget buildPayButton(dynamic transaksi) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
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
