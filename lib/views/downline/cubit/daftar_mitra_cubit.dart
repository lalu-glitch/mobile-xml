import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daftar_mitra_state.dart';

class DaftarMitraCubit extends Cubit<DaftarMitraState> {
  DaftarMitraCubit() : super(DaftarMitraInitial());
}
