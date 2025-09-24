part of 'detail_riwayat_transaksi_cubit.dart';

@immutable
sealed class DetailRiwayatTransaksiState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DetailRiwayatTransaksiInitial extends DetailRiwayatTransaksiState {}

class DetailRiwayatTransaksiLoading extends DetailRiwayatTransaksiState {}

class DetailRiwayatTransaksiSuccess extends DetailRiwayatTransaksiState {
  final StatusTransaksi statusTransaksi;

  DetailRiwayatTransaksiSuccess(this.statusTransaksi);

  @override
  List<Object?> get props => [statusTransaksi];
}

class DetailRiwayatTransaksiError extends DetailRiwayatTransaksiState {
  final String message;

  DetailRiwayatTransaksiError(this.message);

  @override
  List<Object?> get props => [message];
}
