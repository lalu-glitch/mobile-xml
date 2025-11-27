import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/transaksi/status_transaksi.dart';
import '../../../data/services/api_service.dart';

part 'detail_riwayat_transaksi_state.dart';

class DetailRiwayatTransaksiCubit extends Cubit<DetailRiwayatTransaksiState> {
  final ApiService apiService;
  DetailRiwayatTransaksiCubit(this.apiService)
    : super(DetailRiwayatTransaksiInitial());

  Future<void> loadDetailRiwayat(String kode) async {
    emit(DetailRiwayatTransaksiLoading());
    try {
      final result = await apiService.historyDetail(kode);
      emit(DetailRiwayatTransaksiSuccess(result));
    } catch (e) {
      emit(DetailRiwayatTransaksiError("Gagal mengambil detail riwayat: $e"));
    }
  }
}
