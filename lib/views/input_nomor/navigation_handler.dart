import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../layanan/cubit/flow_cubit.dart';

class NavigationHandler {
  final BuildContext context;

  NavigationHandler(this.context);

  void handleBackNavigation() {
    // Membaca Cubit menggunakan context yang diberikan
    try {
      final flowCubit = context.read<FlowCubit>();

      if (flowCubit.state != null && flowCubit.state!.currentIndex > 0) {
        flowCubit.previousPage();
      }
      Navigator.pop(context);
    } catch (e) {
      print('Error accessing FlowCubit: $e');
      Navigator.pop(context);
    }
  }
}
