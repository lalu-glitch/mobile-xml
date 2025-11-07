part of 'riwayat_transaksi_cubit.dart';

@immutable
sealed class RiwayatTransaksiState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RiwayatTransaksiInitial extends RiwayatTransaksiState {}

class RiwayatTransaksiLoading extends RiwayatTransaksiState {}

class RiwayatTransaksiLoadingMore extends RiwayatTransaksiState {
  final List<RiwayatTransaksi> riwayatList;
  final int currentPage;
  final int totalPages;

  RiwayatTransaksiLoadingMore({
    required this.riwayatList,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [riwayatList, currentPage, totalPages];
}

class RiwayatTransaksiSuccess extends RiwayatTransaksiState {
  final List<RiwayatTransaksi> riwayatList;
  final int currentPage;
  final int totalPages;

  RiwayatTransaksiSuccess({
    required this.riwayatList,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [currentPage, totalPages]; //jangan bandingin list
}

class RiwayatTransaksiError extends RiwayatTransaksiState {
  final String message;

  RiwayatTransaksiError(this.message);

  @override
  List<Object?> get props => [message];
}
