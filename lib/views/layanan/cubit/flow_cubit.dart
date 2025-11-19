import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/layanan/flow_state_models.dart';

import '../../../core/helper/dynamic_app_page.dart';
import '../../../data/models/layanan/layanan_model.dart';

class FlowCubit extends Cubit<FlowStateModel?> {
  FlowCubit() : super(null);

  void startFlow(int flowId, IconItem layananItem) {
    resetFlow();
    final sequence = pageSequences[flowId] ?? [];
    emit(
      FlowStateModel(
        flow: flowId,
        layananItem: layananItem,
        currentIndex: 0,
        sequence: sequence,
      ),
    );
  }

  void nextPage() {
    if (state == null) return;
    if (state!.currentIndex + 1 < state!.sequence.length) {
      emit(state!.copyWith(currentIndex: state!.currentIndex + 1));
    }
  }

  void previousPage() {
    if (state!.canGoPrevious) {
      emit(state!.copyWith(currentIndex: state!.currentIndex - 1));
    }
  }

  void resetFlow() {
    emit(null);
  }
}
