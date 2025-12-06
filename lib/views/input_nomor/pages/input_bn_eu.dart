// halaman ini berfungsi untuk handle input BebasNominal dan EndUser (BNEU) dari prefix
// tujuannya agar halaman konfirmasi tidak menerima segala inputan
// sehingga halaman konfirmasi pure nampilin informasi

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/custom_textfield.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../core/utils/rupiah_text_field.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../utils/base_state.dart';
import '../utils/transaksi_helper_cubit.dart';

class InputBebasNominalDanEndUser extends StatefulWidget {
  const InputBebasNominalDanEndUser({super.key});

  @override
  State<InputBebasNominalDanEndUser> createState() =>
      _InputBebasNominalDanEndUserState();
}

class _InputBebasNominalDanEndUserState
    extends BaseInput<InputBebasNominalDanEndUser> {
  final _nominalController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    return buildPopScope(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text(
            transaksi.isBebasNominal ? 'Input Nominal' : 'Input Voucher',
            style: TextStyle(color: kWhite),
          ),
          backgroundColor: kOrange,
          leading: BackButton(
            onPressed: () {
              final flowCubit = context.read<FlowCubit>();
              if (flowCubit.state!.currentIndex > 0) {
                flowCubit.previousPage();
              }
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Card(
                  color: kWhite,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  child: Padding(
                    padding: const .all(16.0),
                    child: Column(
                      children: [
                        infoRow("Nama Produk", transaksi.namaProduk ?? ''),
                        const Divider(height: 24),
                        infoRow(
                          "Total Pembayaran",
                          CurrencyUtil.formatCurrency(transaksi.productPrice),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),

                if (transaksi.isBebasNominal) ...[
                  const SizedBox(height: 20),
                  const Text("Masukkan Bebas Nominal"),
                  SizedBox(height: kSize8),
                  RupiahTextField(controller: _nominalController, fontSize: 20),
                ],
                if (transaksi.isEndUser) ...[
                  const SizedBox(height: 20),
                  const Text("Masukkan Kode Voucher"),
                  SizedBox(height: kSize8),
                  CustomTextField(controller: dataController),
                ],
                SizedBox(height: kSize40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kWhite,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  ),
                  onPressed: handleNextButtonPress,
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(fontWeight: .bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void handleNextButtonPress() {
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;

    final sendTransaksi = context.read<TransaksiHelperCubit>();
    final transaksi = sendTransaksi.getData();

    final int currentIndex = flowState.currentIndex;
    final bool isLastPage = currentIndex == flowState.sequence.length - 1;

    if (dataController.text.isEmpty) {
      showErrorDialog(context, "Inputan tidak boleh kosong");
      return;
    }
    //text handler buat bebas nominal
    log('bebas nominal: ${sendTransaksi.getData().isBebasNominal}');
    if (transaksi.isBebasNominal) {
      final bebasNominalText = dataController.text.trim().replaceAll('.', '');

      if (bebasNominalText.isEmpty) {
        showErrorDialog(context, "Bebas nominal tidak boleh kosong");
        return;
      }
      final nominal = int.tryParse(bebasNominalText);
      if (nominal == null) {
        showErrorDialog(context, "Input harus berupa angka");
        return;
      }
      log('nilai bebas nominal : $nominal');
      sendTransaksi.setbebasNominalValue(nominal);
    } else {
      sendTransaksi.setbebasNominalValue(0);
    }

    //text handler buat endUser
    if (transaksi.isEndUser) {
      final voucherText = dataController.text.trim();
      if (voucherText.isEmpty) {
        showErrorDialog(context, "Voucher tidak boleh kosong");
        return;
      }
      sendTransaksi.setEndUserValue(voucherText);
    } else {
      sendTransaksi.setEndUserValue('');
    }

    if (!isLastPage) {
      final nextPage = flowState.sequence[currentIndex + 1];

      flowCubit.nextPage();

      if (pageRoutes.containsKey(nextPage)) {
        Navigator.pushNamed(context, pageRoutes[nextPage]!);
      } else {
        showErrorDialog(context, "Rute halaman berikutnya tidak ditemukan.");
      }
    } else {
      Navigator.pushNamed(context, '/konfirmasiPembayaran');
    }
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }
}
