import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helper/constant_finals.dart';
import '../core/helper/dynamic_app_page.dart';
import 'layanan/cubit/flow_cubit.dart';

class MultiSubKategoriPage extends StatelessWidget {
  const MultiSubKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final flowCubit = context.read<FlowCubit>();
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final bool isLastPage = currentIndex == sequence.length - 1;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (currentIndex > 0) {
          flowCubit.previousPage();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kOrange,
          iconTheme: IconThemeData(color: kWhite),
          leading: BackButton(
            onPressed: () {
              if (flowCubit.state!.currentIndex > 0) {
                flowCubit.previousPage(); //  sync dengan Cubit
              }
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Center(child: Text('Multi Sub Kategori Page')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: kWhite,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (!isLastPage) {
                    // update index ke halaman berikut
                    final nextPage =
                        flowState.sequence[flowState.currentIndex + 1];

                    flowCubit.nextPage();
                    Navigator.pushNamed(context, pageRoutes[nextPage]!);
                  } else {
                    Navigator.pushNamed(context, '/konfirmasiPembayaran');
                  }
                },
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
