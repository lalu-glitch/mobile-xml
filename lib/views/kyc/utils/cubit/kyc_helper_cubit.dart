import 'package:bloc/bloc.dart';

import 'kyc_helper_model.dart';

class KYCHelperCubit extends Cubit<KYCModel> {
  KYCHelperCubit() : super(const KYCModel());

  void setDataDiri({
    required String nama,
    required String nik,
    required DateTime tanggalLahir,
  }) {
    emit(state.copyWith(name: nama, nik: nik, birthDate: tanggalLahir));
  }

  //setter untuk path foto
  void setFotoKTP(String ktpPath) => emit(state.copyWith(ktpPath: ktpPath));
  void setFotoSelfie(String selfiePath) =>
      emit(state.copyWith(selfiePath: selfiePath));

  void getData() => emit(state);
  void reset() => emit(const KYCModel());
}
