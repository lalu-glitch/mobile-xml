import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/user/edit_info_akun_model.dart';
import '../../../../data/services/api_service.dart';

part 'edit_info_akun_state.dart';

class EditInfoAkunCubit extends Cubit<EditInfoAkunState> {
  final ApiService apiService;
  EditInfoAkunCubit(this.apiService) : super(EditInfoAkunInitial());

  /// Fungsi untuk mengubah markup referral
  Future<void> updateMarkupReferral(int value) async {
    emit(EditInfoAkunLoading());
    try {
      final result = await apiService.editMarkupRef(value);
      emit(EditInfoAkunSuccess(result));
    } catch (e) {
      emit(EditInfoAkunError(e.toString()));
    }
  }

  Future<void> updateKodeReferral(String value) async {
    emit(EditInfoAkunLoading());
    try {
      final result = await apiService.editKodeRef(value);
      emit(EditInfoAkunSuccess(result));
    } catch (e) {
      emit(EditInfoAkunError(e.toString()));
    }
  }
}

// class EditInfoAkunHelperCubit extends Cubit<UserEditModelHelper> {
//   EditInfoAkunHelperCubit() : super(UserEditModelHelper());

//   void setMarkUpReferral(int val) {
//     emit(state.copyWith(markUpReferral: val));
//   }

//   void setKodeReferral(String val) {
//     emit(state.copyWith(kodeReferral: val));
//   }

//   void setNama(String val) {
//     emit(state.copyWith(nama: val));
//   }

//   UserEditModelHelper getData() {
//     return state;
//   }
// }
