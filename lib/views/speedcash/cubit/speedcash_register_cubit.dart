import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/speedcash/speedcash_register_model.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'speedcash_register_state.dart';

class SpeedcashRegisterCubit extends Cubit<SpeedcashRegisterState> {
  final SpeedcashApiService apiService;
  SpeedcashRegisterCubit(this.apiService) : super(SpeedcashRegisterInitial());

  Future<void> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
    required String kodeReseller,
  }) async {
    emit(SpeedcashRegisterLoading());
    try {
      final result = await apiService.speedcashRegister(
        nama: nama,
        phone: phone,
        email: email,
        kodeReseller: kodeReseller,
      );
      emit(SpeedcashRegisterSuccess(result));
    } catch (e) {
      emit(SpeedcashRegisterError(e.toString()));
    }
  }
}
