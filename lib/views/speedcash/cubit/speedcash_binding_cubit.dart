import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/speedcash/speedcash_binding_model.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'speedcash_binding_state.dart';

class SpeedcashBindingCubit extends Cubit<SpeedcashBindingState> {
  final SpeedcashApiService apiService;
  SpeedcashBindingCubit(this.apiService) : super(SpeedcashBindingInitial());

  Future<void> speedcashBinding(String kodeReseller, String phone) async {
    emit(SpeedcashBindingLoading());
    try {
      final result = await apiService.speedcashBinding(kodeReseller, phone);
      emit(SpeedcashBindingSuccess(result));
    } catch (e) {
      emit(SpeedcashBindingError(e.toString()));
    }
  }
}
