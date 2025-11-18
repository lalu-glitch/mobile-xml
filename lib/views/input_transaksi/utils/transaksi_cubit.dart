import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaksi/transaksi_helper.dart';

class TransaksiHelperCubit extends Cubit<TransaksiHelperModel> {
  TransaksiHelperCubit() : super(const TransaksiHelperModel());

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

  //bebas nominal
  void isBebasNominal(int val) {
    emit(state.copyWith(isBebasNominal: val));
  }

  void setbebasNominalValue(int val) {
    emit(state.copyWith(bebasNominalValue: val));
  }

  //kode voucher ini mah aslinya
  void isEndUser(int val) {
    emit(state.copyWith(isendUser: val));
  }

  void setEndUserValue(String val) {
    emit(state.copyWith(endUserValue: val));
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

  void reset() {
    emit(const TransaksiHelperModel());
  }
}
