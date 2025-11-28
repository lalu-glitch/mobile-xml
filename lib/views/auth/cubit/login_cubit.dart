import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;
  LoginCubit(this.authService) : super(LoginInitial());

  Future<void> login(String nomor, String kodeReseller) async {
    emit(LoginLoading());
    try {
      final result = await authService.sendOtp(kodeReseller, nomor);
      if (result["success"] == true) {
        emit(LoginSuccess(result["data"]));
      } else {
        emit(LoginError(result["message"] ?? "Gagal mengirim OTP."));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
