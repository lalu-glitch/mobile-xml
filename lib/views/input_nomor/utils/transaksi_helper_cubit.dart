import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaksi/transaksi_helper.dart';

//cubit ini berguna buat setter semua data dari API untuk dipass ke berbagai page
// kurang lebih kaya temporary value container/database
class TransaksiHelperCubit extends Cubit<TransaksiHelperModel> {
  TransaksiHelperCubit() : super(const TransaksiHelperModel());

  void setKodeproduk(String val) => emit(state.copyWith(kodeProduk: val));
  void setKodeDompet(String val) => emit(state.copyWith(kodeDompet: val));
  void setKodeCatatan(String val) => emit(state.copyWith(kodeCatatan: val));
  void setTujuan(String val) => emit(state.copyWith(tujuan: val));
  void setNamaProduk(String val) => emit(state.copyWith(namaProduk: val));

  /// setter untuk harga produk (dari katalog)
  void setProductPrice(int val) =>
      emit(state.copyWith(productPrice: val.toDouble()));

  /// setter untuk fee/layanan
  void setFee(int val) => emit(state.copyWith(fee: val.toDouble()));

  /// setter untuk final total (tagihan + fee + extras)
  void setFinalTotalTagihan(int val) =>
      emit(state.copyWith(finalTotal: val.toDouble()));

  void setNominalPembayaran(int val) =>
      emit(state.copyWith(nominalPembayaran: val.toDouble()));

  //setter buat omni
  void setKodeCek(String val) => emit(state.copyWith(kodeCek: val));
  void setKodeBayar(String val) => emit(state.copyWith(kodeBayar: val));

  // bebas nominal
  void isBebasNominal(int val) => emit(state.copyWith(isBebasNominal: val));
  void setbebasNominalValue(int val) =>
      emit(state.copyWith(bebasNominalValue: val.toDouble()));
  //end user
  void isEndUser(int val) => emit(state.copyWith(isendUser: val));
  void setEndUserValue(String val) => emit(state.copyWith(endUserValue: val));

  TransaksiHelperModel getData() => state;
  void reset() => emit(const TransaksiHelperModel());
}
