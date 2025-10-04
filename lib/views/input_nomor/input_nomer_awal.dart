import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../../data/models/transaksi/transaksi_helper.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import 'utils/base_state.dart';
import 'utils/transaksi_cubit.dart';
import 'widgets/input_text_field.dart';

class InputNomorPage extends StatefulWidget {
  const InputNomorPage({super.key});

  @override
  State<InputNomorPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends BaseInputNomorState<InputNomorPage> {
  @override
  void handleNextButtonPress() {
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;
    final int currentIndex = flowState.currentIndex;
    final bool isLastPage = currentIndex == flowState.sequence.length - 1;

    if (nomorController.text.isEmpty) {
      showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
      return;
    }

    if (!isLastPage) {
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Input Nomor Tujuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TransaksiCubit, TransaksiHelperModel>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Masukkan Nomor Tujuan"),
                const SizedBox(height: 8),
                buildNomorTextField(
                  controller: nomorController,
                  onPickContact: pickContact,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
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
            );
          },
        ),
      ),
    );
  }
}
