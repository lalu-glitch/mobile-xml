import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/transaksi/riwayat_transaksi.dart';
import '../../../data/services/api_service.dart';

part 'riwayat_transaksi_state.dart';

class RiwayatTransaksiCubit extends Cubit<RiwayatTransaksiState> {
  final ApiService apiService;
  RiwayatTransaksiCubit(this.apiService) : super(RiwayatTransaksiInitial());

  Future<void> loadRiwayat({
    int page = 1,
    int limit = 5,
    bool append = false,
  }) async {
    if (append) {
      if (state is RiwayatTransaksiSuccess) {
        final current = state as RiwayatTransaksiSuccess;
        if (current.currentPage >= current.totalPages) return;
        emit(
          RiwayatTransaksiLoadingMore(
            riwayatList: current.riwayatList,
            currentPage: current.currentPage,
            totalPages: current.totalPages,
          ),
        );
      } else if (state is RiwayatTransaksiLoadingMore) {
        return;
      } else {
        append = false;
      }
    }

    if (!append) {
      emit(RiwayatTransaksiLoading());
    }

    try {
      final response = await apiService.fetchHistory(page: page, limit: limit);

      List<RiwayatTransaksi> newList = [];
      int newCurrentPage = 1;
      int newTotalPages = 1;

      if (response != null) {
        newCurrentPage = response.currentPage;
        newTotalPages = response.totalPages;
        newList = response.items;
      }

      if (append && (state is RiwayatTransaksiLoadingMore)) {
        final current = state as RiwayatTransaksiLoadingMore;
        newList = List.from(current.riwayatList)..addAll(newList);
      }

      emit(
        RiwayatTransaksiSuccess(
          riwayatList: newList,
          currentPage: newCurrentPage,
          totalPages: newTotalPages,
        ),
      );
    } catch (e) {
      emit(RiwayatTransaksiError(e.toString()));
    }
  }

  Future<void> loadNextPage({int limit = 5}) async {
    if (state is RiwayatTransaksiSuccess) {
      final current = state as RiwayatTransaksiSuccess;
      await loadRiwayat(
        page: current.currentPage + 1,
        limit: limit,
        append: true,
      );
    } else if (state is RiwayatTransaksiLoadingMore) {
      //udah loading, gausah ngapa ngapain
    }
  }
}
