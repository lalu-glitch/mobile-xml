import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/api_service.dart';

part 'daftar_mitra_state.dart';

class DaftarMitraCubit extends Cubit<DaftarMitraState> {
  final ApiService apiService;
  DaftarMitraCubit(this.apiService) : super(DaftarMitraInitial());

  Future<void> daftarMitra({
    required String nama,
    required String alamat,
    required String nomor,
    required int markup,
    required String kodeReseller,
  }) async {
    emit(DaftarMitraLoading());

    try {
      final message = await apiService.daftarDownline(
        nama,
        alamat,
        nomor,
        markup,
        kodeReseller,
      );

      emit(DaftarMitraSuccess(message));
    } catch (e) {
      emit(DaftarMitraError(e.toString()));
    }
  }
}
