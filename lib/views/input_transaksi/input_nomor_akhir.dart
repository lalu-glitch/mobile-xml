import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/currency.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import '../../core/utils/rupiah_text_field.dart';
import 'utils/base_state.dart';
import 'utils/transaksi_cubit.dart';
import '../../core/utils/info_row.dart';
import 'widgets/input_text_field.dart';

class InputNomorTujuanAkhir extends StatefulWidget {
  const InputNomorTujuanAkhir({super.key});

  @override
  State<InputNomorTujuanAkhir> createState() => _InputNomorTujuanAkhirState();
}

class _InputNomorTujuanAkhirState extends BaseInput<InputNomorTujuanAkhir> {
  final TextEditingController _bebasNominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    return WillPopScope(
      onWillPop: onWillPopLogic,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: const Text(
            "Input Nomor Tujuan",
            style: TextStyle(color: kWhite),
          ),
          leading: BackButton(
            onPressed: () {
              final flowCubit = context.read<FlowCubit>();
              if (flowCubit.state!.currentIndex > 0) {
                flowCubit.previousPage();
              }
              Navigator.pop(context);
            },
          ),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: kWhite,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        infoRow("Nama Produk", transaksi.namaProduk ?? ''),
                        const Divider(height: 24),
                        infoRow(
                          "Total Pembayaran",
                          CurrencyUtil.formatCurrency(transaksi.total),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Masukkan Nomor Tujuan"),
                const SizedBox(height: 8),

                buildNomorTextField(
                  controller: dataController,
                  onPickContact: pickContact,
                ),

                SizedBox(height: kSize14),
                Visibility(
                  visible: transaksi.isBebasNominal == 1,
                  child: const Text("Masukkan Nominal"),
                ),
                Visibility(
                  visible: transaksi.isBebasNominal == 1,
                  child: SizedBox(height: kSize8),
                ),
                Visibility(
                  visible: transaksi.isBebasNominal == 1,
                  child: RupiahTextField(
                    controller: _bebasNominalController,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kWhite,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: handleNextButtonPress,
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
      showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
      return;
    }
    if (transaksi.isBebasNominal == 1) {
      final bebasNominalText = _bebasNominalController.text.trim().replaceAll(
        '.',
        '',
      );

      if (bebasNominalText.isEmpty) {
        showErrorDialog(context, "Bebas nominal tidak boleh kosong");
        return;
      }
      final nominal = int.tryParse(bebasNominalText);
      if (nominal == null) {
        showErrorDialog(context, "Input harus berupa angka");
        return;
      }

      sendTransaksi.setbebasNominalValue(nominal);
    } else {
      sendTransaksi.setbebasNominalValue(0);
    }

    sendTransaksi.setTujuan(dataController.text);

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
    _bebasNominalController.dispose();
    super.dispose();
  }
}
