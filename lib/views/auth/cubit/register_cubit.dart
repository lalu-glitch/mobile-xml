import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService authService;
  RegisterCubit(this.authService) : super(RegisterInitial());

  Future<void> registerUser({
    required String namaUsaha,
    required String namaLengkap,
    required String nomor,
    required String alamat,
    required String provinsi,
    required String kabupaten,
    required String kecamatan,
    required String referral,
  }) async {
    emit(RegisterLoading());

    try {
      final result = await authService.onRegisterUser(
        namaUsaha,
        namaLengkap,
        nomor,
        alamat,
        provinsi,
        kabupaten,
        kecamatan,
        referral,
      );

      if (result["success"] == true) {
        emit(RegisterSuccess(result["data"]));
      } else {
        emit(RegisterError("Gagal register"));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
