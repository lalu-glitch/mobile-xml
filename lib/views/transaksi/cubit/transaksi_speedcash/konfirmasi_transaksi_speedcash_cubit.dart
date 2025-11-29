import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/speedcash/speedcash_konfirmasi_transaksi_model.dart';
import '../../../../data/services/speedcash_api_service.dart';

part 'konfirmasi_transaksi_speedcash_state.dart';

class KonfirmasiTransaksiSpeedcashCubit
    extends Cubit<KonfirmasiTransaksiSpeedcashState> {
  final SpeedcashApiService apiService;
  KonfirmasiTransaksiSpeedcashCubit(this.apiService)
    : super(KonfirmasiTransaksiSpeedcashInitial());

  Future<void> konfirmasiTransaksiSpeedcash(
    String kodeReseller,
    String kodeProduk,
    String tujuan, {
    int qty = 0,
    String endUser = '',
  }) async {
    emit(KonfirmasiTransaksiSpeedcashLoading());
    try {
      final data = await apiService.konfirmasiTransaksiSpeedcash(
        kodeReseller,
        kodeProduk,
        tujuan,
        qty,
        endUser,
      );
      emit(KonfirmasiTransaksiSpeedcashSuccess(data: data));
    } catch (e) {
      emit(KonfirmasiTransaksiSpeedcashError(message: "Ada yang salah"));
    }
  }
}
