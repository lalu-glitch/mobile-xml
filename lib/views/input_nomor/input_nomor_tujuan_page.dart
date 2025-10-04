import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/currency.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import 'base_state.dart';
import 'transaksi_cubit.dart';
import 'widgets/nomor_text_field.dart';

class InputNomorTujuanPage extends StatefulWidget {
  const InputNomorTujuanPage({super.key});

  @override
  State<InputNomorTujuanPage> createState() => _InputNomorTujuanPageState();
}

class _InputNomorTujuanPageState
    extends BaseInputNomorState<InputNomorTujuanPage> {
  final TextEditingController _bebasNominalController = TextEditingController();

  @override
  void handleNextButtonPress() {
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;

    final sendTransaksi = context.read<TransaksiCubit>();
    final transaksi = sendTransaksi.getData();

    final int currentIndex = flowState.currentIndex;
    final bool isLastPage = currentIndex == flowState.sequence.length - 1;

    if (nomorController.text.isEmpty) {
      showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
      return;
    }
    if (transaksi.isBebasNominal == 1) {
      final bebasNominalText = _bebasNominalController.text.trim();

      // Validasi Kosong
      if (bebasNominalText.isEmpty) {
        showErrorDialog(context, "Bebas nominal tidak boleh kosong");
        return;
      }
      final nominal = int.tryParse(bebasNominalText);
      if (nominal == null) {
        showErrorDialog(context, "Input harus berupa angka");
        return;
      }

      sendTransaksi.bebasNominalValue(nominal);
    } else {
      sendTransaksi.bebasNominalValue(0);
    }

    sendTransaksi.setTujuan(nomorController.text);

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
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiCubit>().getData();
    return WillPopScope(
      onWillPop: onWillPopLogic,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _infoRow("Nama Produk", transaksi.namaProduk ?? ''),
                      const Divider(height: 24),
                      _infoRow(
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
                controller: nomorController,
                onPickContact: pickContact,
              ),

              SizedBox(height: Screen.kSize14),
              Visibility(
                visible: transaksi.isBebasNominal == 1,
                child: const Text("Masukkan Nominal"),
              ),
              Visibility(
                visible: transaksi.isBebasNominal == 1,
                child: SizedBox(height: Screen.kSize8),
              ),
              Visibility(
                visible: transaksi.isBebasNominal == 1,
                child: TextField(
                  controller: _bebasNominalController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Input nominal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    suffixIcon: const Icon(Icons.attach_money_rounded),
                  ),
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
    );
  }

  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? Screen.kSize16 : Screen.kSize14,
              color: isTotal ? kOrange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bebasNominalController.dispose();
    super.dispose();
  }
}
