import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user/region.dart';
import '../../../data/services/auth_service.dart';

part 'wilayah_state.dart';

class WilayahCubit extends Cubit<WilayahState> {
  final AuthService apiService;
  WilayahCubit(this.apiService) : super(WilayahInitial());

  Future<void> fetchProvinsi() async {
    emit(WilayahLoading());
    try {
      final result = await apiService.fetchProvinsi();
      emit(WilayahLoaded(result.data));
    } catch (e) {
      emit(WilayahError(e.toString()));
    }
  }

  Future<void> fetchKabupaten(String kodeKabupaten) async {
    emit(WilayahLoading());
    try {
      final result = await apiService.fetchKabupaten(kodeKabupaten);
      emit(WilayahLoaded(result.data));
    } catch (e) {
      emit(WilayahError(e.toString()));
    }
  }

  Future<void> getKecamatan(String kodeProvinsi, String kodeKabupaten) async {
    emit(WilayahLoading());
    try {
      final result = await apiService.fetchKecamatan(
        kodeProvinsi,
        kodeKabupaten,
      );
      emit(WilayahLoaded(result.data));
    } catch (e) {
      emit(WilayahError(e.toString()));
    }
  }
}
