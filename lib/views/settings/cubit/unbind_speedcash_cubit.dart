import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/services/speedcash_api_service.dart';

part 'unbind_speedcash_state.dart';

class UnbindSpeedCashCubit extends Cubit<SpeedcashState> {
  final SpeedcashApiService apiService;

  UnbindSpeedCashCubit(this.apiService) : super(SpeedcashInitial());

  Future<void> unbindAccount() async {
    emit(UnbindLoading());

    final result = await apiService.speedcashUnbind();

    if (result.success == true) {
      emit(UnbindSuccess(result.message));
    } else {
      emit(UnbindError(result.message));
    }
  }
}
