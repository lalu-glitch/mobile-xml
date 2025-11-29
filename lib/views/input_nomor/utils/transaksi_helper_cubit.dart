import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaksi/transaksi_helper_model.dart';

//cubit ini berguna buat setter semua data dari API untuk dipass ke berbagai page
// kurang lebih kaya temporary value container/database
class TransaksiHelperCubit extends Cubit<TransaksiHelperModel> {
  TransaksiHelperCubit() : super(const TransaksiHelperModel());

  void setKodeDompet(String val) => emit(state.copyWith(kodeDompet: val));
  void setTujuan(String val) => emit(state.copyWith(tujuan: val));

  /// setter untuk fee/layanan
  void setFee(int val) => emit(state.copyWith(fee: val.toDouble()));

  /// setter untuk final total (tagihan + fee + extras)
  void setFinalTotalTagihan(int val) =>
      emit(state.copyWith(finalTotal: val.toDouble()));
  void setNominalPembayaran(int val) =>
      emit(state.copyWith(nominalPembayaran: val.toDouble()));

  void setbebasNominalValue(int val) =>
      emit(state.copyWith(bebasNominalValue: val.toDouble()));
  void setEndUserValue(String val) => emit(state.copyWith(endUserValue: val));

  TransaksiHelperModel getData() => state;
  void reset() => emit(const TransaksiHelperModel());

  /// NEW
  void pilihProduk({
    required String kode,
    required String nama,
    required double harga,
    required int isBebasNominalApi, // Terima mentah dari API (0/1)
    required int isEndUserApi, // Terima mentah dari API (0/1)
    String? kodeCatatan,
    String? kodeCek,
    String? kodeBayar,
  }) {
    emit(
      state.copyWith(
        kodeProduk: kode,
        namaProduk: nama,
        productPrice: harga,
        // Konversi 0/1 jadi true/false di sini. UI terima beres.
        isBebasNominal: isBebasNominalApi == 1,
        isEndUser: isEndUserApi == 1,
        // Sekalian simpan data lain biar gak panggil setter berkali-kali
        kodeCatatan: kodeCatatan,
        kodeCek: kodeCek,
        kodeBayar: kodeBayar,

        // Reset inputan user sebelumnya biar aman
        bebasNominalValue: 0,
        endUserValue: '',
        tujuan: '',
      ),
    );
  }

  void pilihMenuLayanan({
    required String kodeCatatan,
    String? kodeCek,
    String? kodeBayar,
  }) {
    emit(
      state.copyWith(
        kodeCatatan: kodeCatatan,
        kodeCek: kodeCek,
        kodeBayar: kodeBayar,
      ),
    );
  }
}
