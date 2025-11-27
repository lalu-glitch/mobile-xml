part of 'konfirmasi_transaksi_speedcash_cubit.dart';

@immutable
sealed class KonfirmasiTransaksiSpeedcashState {}

final class KonfirmasiTransaksiSpeedcashInitial
    extends KonfirmasiTransaksiSpeedcashState {}

final class KonfirmasiTransaksiSpeedcashLoading
    extends KonfirmasiTransaksiSpeedcashState {}

final class KonfirmasiTransaksiSpeedcashSuccess
    extends KonfirmasiTransaksiSpeedcashState {
  final SpeedcashKonfirmasiTransaksiModel data;

  KonfirmasiTransaksiSpeedcashSuccess({required this.data});
}

final class KonfirmasiTransaksiSpeedcashError
    extends KonfirmasiTransaksiSpeedcashState {
  final String message;

  KonfirmasiTransaksiSpeedcashError({required this.message});
}
