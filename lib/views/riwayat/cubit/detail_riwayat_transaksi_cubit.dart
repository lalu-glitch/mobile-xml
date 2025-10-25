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
      if (result['success'] == true) {
        final data = result['data'];
        final statusTransaksi = StatusTransaksiModel.fromJson(
          data as Map<String, dynamic>,
        );
        emit(DetailRiwayatTransaksiSuccess(statusTransaksi));
      } else {
        emit(
          DetailRiwayatTransaksiError(
            result['message']?.toString() ?? "Gagal mengambil detail riwayat",
          ),
        );
      }
    } catch (e) {
      emit(DetailRiwayatTransaksiError("Gagal mengambil detail riwayat: $e"));
    }
  }
}
