import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../views/layanan/cubit/flow_cubit.dart';

class NavigationHandler {
  final BuildContext context;

  NavigationHandler(this.context);

  /// Menangani navigasi mundur dan sinkronisasi state FlowCubit.
  void handleBackNavigation() {
    // Membaca Cubit menggunakan context yang diberikan
    try {
      final flowCubit = context.read<FlowCubit>();

      // Cek State Cubit untuk menentukan apakah ada halaman sebelumnya
      if (flowCubit.state != null && flowCubit.state!.currentIndex > 0) {
        flowCubit.previousPage(); // Sinkronkan state Cubit
      }
      // Selalu pop Navigator (jika currentIndex == 0, Navigator tetap di-pop)
      Navigator.pop(context);
    } catch (e) {
      // Jika Cubit tidak ditemukan, tetap pop untuk mencegah stuck
      print('Error accessing FlowCubit: $e');
      Navigator.pop(context);
    }
  }
}
