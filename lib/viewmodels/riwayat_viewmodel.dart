import 'package:flutter/material.dart';
import '../data/models/status_transaksi.dart';
import '../data/models/transaksi_riwayat.dart';
import '../data/services/api_service.dart';

class RiwayatTransaksiViewModel extends ChangeNotifier {
  final ApiService apiService;

  RiwayatTransaksiViewModel({ApiService? service})
    : apiService = service ?? ApiService();

  List<RiwayatTransaksi> riwayatList = [];
  StatusTransaksi? statusTransaksi;

  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  String? error;
  Future<void> loadRiwayat({
    int page = 1,
    int limit = 5,
    bool append = false,
  }) async {
    isLoading = true;
    notifyListeners();

    final response = await apiService.fetchHistory(page: page, limit: limit);

    if (response != null) {
      currentPage = response.currentPage;
      totalPages = response.totalPages;

      if (append) {
        riwayatList.addAll(response.items);
      } else {
        riwayatList = response.items;
      }
    } else {
      riwayatList = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // Optional: load next page
  Future<void> loadNextPage({int limit = 5}) async {
    if (currentPage < totalPages && !isLoading) {
      await loadRiwayat(page: currentPage + 1, limit: limit, append: true);
    }
  }

  Future<void> loadDetailRiwayat(String kode) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await apiService.historyDetail(kode);

      if (result['success'] == true) {
        final data = result['data'];
        if (data is StatusTransaksi) {
          statusTransaksi = data;
        } else if (data is Map<String, dynamic>) {
          statusTransaksi = StatusTransaksi.fromJson(data);
        } else {
          throw Exception("Format data tidak dikenali");
        }
      } else {
        error =
            result['message']?.toString() ?? "Gagal mengambil detail riwayat";
      }
    } catch (e) {
      error = "Gagal mengambil detail riwayat: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
