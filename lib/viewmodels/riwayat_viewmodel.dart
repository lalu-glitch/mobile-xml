import 'package:flutter/material.dart';
import '../models/transaksi_riwayat.dart';
import '../services/api_service.dart';

class RiwayatTransaksiViewModel extends ChangeNotifier {
  final ApiService apiService;

  RiwayatTransaksiViewModel({ApiService? service})
    : apiService = service ?? ApiService();

  List<RiwayatTransaksi> riwayatList = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;

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
}
