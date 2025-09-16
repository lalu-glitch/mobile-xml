import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/transaksi/transaksi_helper_model.dart';

class TransaksiCubit extends Cubit<TransaksiModel> {
  TransaksiCubit() : super(const TransaksiModel());

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

  void setFileName(String val) {
    emit(state.copyWith(filename: val));
  }

  TransaksiModel getData() {
    return state;
  }

  Map<String, dynamic> toMap() {
    return {
      'kodeProduk': state.kodeProduk,
      'tujuan': state.tujuan,
      'namaProduk': state.namaProduk,
      'total': state.total,
    };
  }
}
