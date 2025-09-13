import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user/info_akun.dart';
import '../../../data/services/api_service.dart';

part 'info_akun_state.dart';

class InfoAkunCubit extends Cubit<InfoAkunState> {
  final ApiService apiService;

  InfoAkunCubit(this.apiService) : super(InfoAkunInitial());

  Future<void> getInfoAkun() async {
    emit(InfoAkunLoading());
    try {
      final result = await apiService.infoAkun();
      emit(InfoAkunSuccess(result));
    } catch (e) {
      emit(InfoAkunError(e.toString()));
    }
  }
}
