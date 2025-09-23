import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/flow_state_models.dart';
import '../../../data/models/icon_models/icon_data.dart';
import '../../../core/helper/dynamic_app_page.dart';

class FlowCubit extends Cubit<FlowStateModel?> {
  FlowCubit() : super(null);

  void startFlow(int flowId, IconItem iconItem) {
    resetFlow();
    final sequence = pageSequences[flowId] ?? [];
    emit(
      FlowStateModel(
        flow: flowId,
        iconItem: iconItem,
        currentIndex: 0,
        sequence: sequence,
      ),
    );
  }

  void nextPage() {
    if (state == null) return;
    if (state!.currentIndex + 1 < state!.sequence.length) {
      final newIndex = state!.currentIndex + 1;
      emit(state!.copyWith(currentIndex: state!.currentIndex + 1));
    }
  }

  void previousPage() {
    if (state!.currentIndex > 0) {
      emit(state!.copyWith(currentIndex: state!.currentIndex - 1));
    }
  }

  void resetFlow() {
    emit(null);
  }
}
