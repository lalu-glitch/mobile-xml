import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/speedcash_api_service.dart';

part 'unbind_ewallet.dart';

class UnbindEwalletCubit extends Cubit<EwalletState> {
  final SpeedcashApiService apiService;

  UnbindEwalletCubit(this.apiService) : super(EwalletInitial());

  // Future<void> unbindSpeedcash(String kodeReseller) async {
  //   emit(UnbindLoading(kodeReseller));

  //   try {

  //       final result = await apiService.speedcashUnbind(kodeReseller);
  //       if (result.success == true) {
  //         emit(UnbindSuccess(result.message, kodeReseller));
  //       } else {
  //         emit(UnbindError(result.message, kodeReseller));
  //       }
  //     }
  //   } catch (e) {
  //     emit(UnbindError('Gagal unbind: $e', kodeDompet ?? 'N/A'));
  //   }
  // }

  Future<void> unbindSpeedcash(String kodeReseller) async {
    emit(UnbindLoading(kodeReseller));
    try {
      final result = await apiService.speedcashUnbind(kodeReseller);
      if (result.success == true) {
        emit(UnbindSuccess(result.message, kodeReseller));
      } else {
        emit(UnbindError(result.message, kodeReseller));
      }
    } catch (e) {
      emit(UnbindError('Gagal unbind: $e', kodeReseller));
    }
  }
}
