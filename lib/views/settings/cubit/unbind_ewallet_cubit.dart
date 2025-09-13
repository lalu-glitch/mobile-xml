import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'unbind_ewallet.dart';

class UnbindEwalletCubit extends Cubit<EwalletState> {
  final SpeedcashApiService apiService;

  UnbindEwalletCubit({required this.apiService}) : super(EwalletInitial());

  Future<void> unbindEwallet(String kodeDompet) async {
    emit(UnbindLoading(kodeDompet));
    try {
      if (kodeDompet == 'SP') {
        final result = await apiService.speedcashUnbind();
        if (result.success == true) {
          emit(UnbindSuccess(result.message, kodeDompet));
        } else {
          emit(UnbindError(result.message, kodeDompet));
        }
      } else {
        // TODO: Implement unbind for other e-wallets (e.g., Nobu Bank)
        emit(
          UnbindError(
            'Unbind untuk $kodeDompet belum diimplementasikan',
            kodeDompet,
          ),
        );
      }
    } catch (e) {
      emit(UnbindError('Gagal unbind: $e', kodeDompet));
    }
  }
}
