import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/speedcash/speedcash_payment_transaksi_model.dart';
import '../../../../data/services/speedcash_api_service.dart';

part 'pembayaran_transaksi_speedcash_state.dart';

class PembayaranTransaksiSpeedcashCubit
    extends Cubit<PembayaranTransaksiSpeedcashState> {
  final SpeedcashApiService apiService;
  PembayaranTransaksiSpeedcashCubit(this.apiService)
    : super(PembayaranTransaksiSpeedcashInitial());

  Future<void> pembayaranTransaksiSpeedcash(
    String kodeReseller,
    String originPartnerReffNumber,
  ) async {
    emit(PembayaranTransaksiSpeedcashLoading());
    try {
      final data = await apiService.pembayaranTransaksiSpeedcash(
        kodeReseller,
        originPartnerReffNumber,
      );
      emit(PembayaranTransaksiSpeedcashSuccess(data));
    } catch (e) {
      emit(PembayaranTransaksiSpeedcashError("Ada yang salah"));
    }
  }
}
