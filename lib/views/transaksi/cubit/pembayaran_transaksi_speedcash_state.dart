part of 'pembayaran_transaksi_speedcash_cubit.dart';

@immutable
sealed class PembayaranTransaksiSpeedcashState {}

final class PembayaranTransaksiSpeedcashInitial
    extends PembayaranTransaksiSpeedcashState {}

final class PembayaranTransaksiSpeedcashLoading
    extends PembayaranTransaksiSpeedcashState {}

final class PembayaranTransaksiSpeedcashSuccess
    extends PembayaranTransaksiSpeedcashState {
  final SpeedcashPaymentTransaksiModel data;

  PembayaranTransaksiSpeedcashSuccess(this.data);
}

final class PembayaranTransaksiSpeedcashError
    extends PembayaranTransaksiSpeedcashState {
  final String message;

  PembayaranTransaksiSpeedcashError(this.message);
}
