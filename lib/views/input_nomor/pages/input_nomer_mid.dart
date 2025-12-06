import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/info_row.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../../core/utils/dialog.dart';
import '../utils/base_state.dart';
import '../utils/transaksi_helper_cubit.dart';
import '../widgets/widget_input_text_field.dart';

class InputNomorMidPage extends StatefulWidget {
  const InputNomorMidPage({super.key});

  @override
  State<InputNomorMidPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends BaseInput<InputNomorMidPage> {
  @override
  void handleNextButtonPress() {
    final sendTransaksi = context.read<TransaksiHelperCubit>();
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;
    final int currentIndex = flowState.currentIndex;
    final bool isLastPage = currentIndex == flowState.sequence.length - 1;

    if (dataController.text.isEmpty) {
      showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
      return;
    }

    if (!isLastPage) {
      sendTransaksi.setTujuan(dataController.text);
      final nextPage = flowState.sequence[currentIndex + 1];
      flowCubit.nextPage();
      Navigator.pushNamed(context, pageRoutes[nextPage]!);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Flow selesai")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    return buildPopScope(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: const Text(
            "Input Nomor Tujuan",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kOrange,
          iconTheme: IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const .all(16.0),
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
              const SizedBox(height: 20),
              const Text("Masukkan Nomor Tujuan"),
              const SizedBox(height: 8),
              buildNomorTextField(
                controller: dataController,
                onPickContact: pickContact,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: Colors.white,
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
    );
  }
}
