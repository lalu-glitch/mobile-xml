import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/services/auth_service.dart';

part 'request_kode_agen_state.dart';

class RequestKodeAgenCubit extends Cubit<RequestKodeAgenState> {
  final AuthService apiService;
  RequestKodeAgenCubit(this.apiService) : super(RequestKodeAgenInitial());

  Future<void> requestKodeAgen(String nomor) async {
    emit(RequestKodeAgenLoading());
    try {
      await apiService.requestKodeAgen(nomor);
      emit(RequestKodeAgenLoaded());
    } catch (e) {
      emit(RequestKodeAgenError(e.toString()));
    }
  }
}
