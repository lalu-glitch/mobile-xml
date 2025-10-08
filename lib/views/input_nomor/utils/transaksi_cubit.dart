import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaksi/transaksi_helper.dart';

class TransaksiCubit extends Cubit<TransaksiHelperModel> {
  TransaksiCubit() : super(const TransaksiHelperModel());

  void setKodeproduk(String val) {
    emit(state.copyWith(kodeProduk: val));
  }

  void setTujuan(String val) {
    emit(state.copyWith(tujuan: val));
  }

  void setNamaProduk(String val) {
    emit(state.copyWith(namaProduk: val));
  }

  void setNominal(int val) {
    emit(state.copyWith(total: val.toDouble()));
  }

  void isBebasNominal(int val) {
    emit(state.copyWith(isBebasNominal: val));
  }

  void bebasNominalValue(int val) {
    emit(state.copyWith(bebasNominalValue: val));
  }

  void setKodeDompet(String val) {
    emit(state.copyWith(kodeDompet: val));
  }

  void setKodeCatatan(String val) {
    emit(state.copyWith(kodeCatatan: val));
  }

  TransaksiHelperModel getData() {
    return state;
  }
}
