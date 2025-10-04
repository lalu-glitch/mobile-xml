// base_input_state.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../layanan/cubit/flow_cubit.dart';
import 'contact_handler.dart';
import 'navigation_handler.dart';

// Tipe generik T adalah untuk Widget, S untuk State
abstract class BaseInputNomorState<T extends StatefulWidget> extends State<T> {
  // Properti yang sama di semua halaman
  final TextEditingController nomorController = TextEditingController();

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
      nomorController: nomorController,
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

  // Anda juga bisa menempatkan implementasi onWillPop di sini jika sama
  Future<bool> onWillPopLogic() async {
    final flowState = context.read<FlowCubit>().state!;
    if (flowState.currentIndex > 0) {
      navigationHandler.handleBackNavigation();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nomorController.dispose();
    super.dispose();
  }
}
