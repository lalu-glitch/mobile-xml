import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import 'utils/base_state.dart';
import 'widgets/input_text_field.dart';

class InputNomorMidPage extends StatefulWidget {
  const InputNomorMidPage({super.key});

  @override
  State<InputNomorMidPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends BaseInputNomorState<InputNomorMidPage> {
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
    return WillPopScope(
      onWillPop: onWillPopLogic,
      child: Scaffold(
        backgroundColor: kNeutral20,
        appBar: AppBar(
          title: const Text(
            "Input Nomor Tujuan",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kOrange,
          iconTheme: IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
