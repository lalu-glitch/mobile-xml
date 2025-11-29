import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/transaksi/riwayat_transaksi_model.dart';
import '../../../data/services/api_service.dart';

part 'riwayat_transaksi_state.dart';

class RiwayatTransaksiCubit extends Cubit<RiwayatTransaksiState> {
  final ApiService apiService;
  bool _isLoadingMore = false;

  RiwayatTransaksiCubit(this.apiService) : super(RiwayatTransaksiInitial());

  Future<void> loadRiwayat({
    int page = 1,
    int limit = 5,
    bool append = false,
  }) async {
    List<RiwayatTransaksi> previousList = [];

    if (append) {
      if (state is RiwayatTransaksiSuccess) {
        final current = state as RiwayatTransaksiSuccess;
        if (current.currentPage >= current.totalPages) return;
        previousList = current.riwayatList;
        emit(
          RiwayatTransaksiLoadingMore(
            riwayatList: previousList,
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

    if (!append) emit(RiwayatTransaksiLoading());

    try {
      final response = await apiService.fetchRiwayat(page: page, limit: limit);

      final newList = response?.items ?? [];
      final newCurrentPage = response?.currentPage ?? 1;
      final newTotalPages = response?.totalPages ?? 1;

      final combinedList = append
          ? UnmodifiableListView([...previousList, ...newList])
          : UnmodifiableListView(newList);

      // Hindari emit berulang
      if (state is RiwayatTransaksiSuccess) {
        final current = state as RiwayatTransaksiSuccess;
        if (current.currentPage == newCurrentPage &&
            current.totalPages == newTotalPages &&
            current.riwayatList.length == combinedList.length) {
          return;
        }
      }

      emit(
        RiwayatTransaksiSuccess(
          riwayatList: combinedList,
          currentPage: newCurrentPage,
          totalPages: newTotalPages,
        ),
      );
    } catch (e) {
      emit(RiwayatTransaksiError(e.toString()));
      if (e is Exception) {
        emit(
          RiwayatTransaksiError(e.toString().replaceFirst('Exception: ', '')),
        );
      } else {
        emit(RiwayatTransaksiError(e.toString()));
      }
    }
  }

  Future<void> loadNextPage({int limit = 5}) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      if (state is RiwayatTransaksiSuccess) {
        final current = state as RiwayatTransaksiSuccess;
        await loadRiwayat(
          page: current.currentPage + 1,
          limit: limit,
          append: true,
        );
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
