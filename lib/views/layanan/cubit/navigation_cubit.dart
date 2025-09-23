import 'package:bloc/bloc.dart';
import '../../../core/helper/dynamic_app_page.dart';

class NavigationState {
  final List<AppPage> sequence;
  final int currentIndex;
  final Map<String, dynamic>
  data; // e.g. {'iconItem': IconItem, 'nomorTujuan': '123'}

  NavigationState({
    required this.sequence,
    this.currentIndex = 0,
    this.data = const {},
  });

  NavigationState copyWith({
    List<AppPage>? sequence,
    int? currentIndex,
    Map<String, dynamic>? data,
  }) {
    return NavigationState(
      sequence: sequence ?? this.sequence,
      currentIndex: currentIndex ?? this.currentIndex,
      data: data ?? this.data,
    );
  }
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(sequence: []));

  void initSequence(
    List<AppPage> sequence, {
    Map<String, dynamic>? initialData,
  }) {
    emit(
      NavigationState(
        sequence: sequence,
        currentIndex: 0,
        data: initialData ?? {},
      ),
    );
  }

  void nextStep() {
    if (state.currentIndex < state.sequence.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    } else {
      // Flow selesai, bisa emit event atau handle di page terakhir
      print('Flow selesai');
    }
  }

  void previousStep() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  void updateData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.data);
    newData[key] = value;
    emit(state.copyWith(data: newData));
  }

  void reset() {
    emit(NavigationState(sequence: []));
  }
}
