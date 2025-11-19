import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_handler.dart';
import '../../layanan/cubit/flow_cubit.dart';
import 'contact_handler.dart';

// Tipe generik T adalah untuk Widget, S untuk State
abstract class BaseInput<T extends StatefulWidget> extends State<T> {
  // Properti yang sama di semua halaman
  final TextEditingController dataController = TextEditingController();

  // Handlers yang sama di semua halaman
  late final NavigationHandler navigationHandler;
  late final ContactFlowHandler handler;

  @override
  void initState() {
    super.initState();
    // Inisialisasi properti yang sama
    navigationHandler = NavigationHandler(context);
    handler = ContactFlowHandler(
      context: context,
      nomorController: dataController,
      setStateCallback: (fn) {
        if (mounted) {
          setState(fn);
        }
      },
    );
  }

  // Metode untuk logika yang sama (contoh: fungsi pick contact)
  void pickContact() {
    handler.pickContact();
  }

  // Metode Abstrak (Wajib di-implementasikan)
  // Untuk Judul dan Logika Tombol Selanjutnya, karena pasti berbeda
  void handleNextButtonPress();

  // Menggunakan PopScope
  PopScope buildPopScope({required Widget child}) {
    return PopScope(
      canPop: false, // Kita kontrol manual
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // NULL SAFE CHECK - REKOMENDASI #3
        final flowCubit = context.read<FlowCubit>();
        final state = flowCubit.state;

        if (state != null && state.canGoPrevious) {
          flowCubit.previousPage();
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }

  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }
}
