part of 'riwayat_transaksi_cubit.dart';

@immutable
sealed class RiwayatTransaksiState {}

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
}

class RiwayatTransaksiError extends RiwayatTransaksiState {
  final String message;

  RiwayatTransaksiError(this.message);
}
