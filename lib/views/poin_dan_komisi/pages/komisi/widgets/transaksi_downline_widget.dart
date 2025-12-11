import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/constant_finals.dart';
import '../../../../../core/helper/error_handler.dart';
import '../../../../downline/cubit/list_mitra_cubit.dart';
import '../../../../settings/cubit/info_akun/info_akun_cubit.dart';
import 'downline_widget_card.dart';

class TransaksiDownlineTabPage extends StatelessWidget {
  const TransaksiDownlineTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    String kodeReseller = '';

    //dapetin kode reseller
    final infoAkunState = context.read<InfoAkunCubit>().state;
    kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };

    void fetchData() {
      context.read<ListMitraCubit>().fetchMitraList(kodeReseller);
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: BlocBuilder<ListMitraCubit, ListMitraState>(
        builder: (context, state) {
          if (state is ListMitraInitial) {
            fetchData();
          }
          if (state is ListMitraLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kOrange, strokeWidth: 3),
            );
          }
          if (state is ListMitraLoaded) {
            return ListView.builder(
              padding: const .all(16.0),
              itemCount: state.mitraList.length,
              itemBuilder: (context, index) {
                return DownlineCard(mitra: state.mitraList[index]);
              },
            );
          }
          if (state is ListMitraError) {
            return Center(
              child: SizedBox(
                child: ErrorHandler(
                  message: "Ada yang salah!",
                  onRetry: fetchData,
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
