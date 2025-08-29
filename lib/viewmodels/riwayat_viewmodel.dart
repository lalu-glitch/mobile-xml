import 'package:flutter/foundation.dart';
import '../models/transaksi_riwayat.dart';
import '../services/api_service.dart';

class HistoryViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Transaksi> transaksi = [];
  bool isLoading = false;
  bool hasMore = true;

  int currentPage = 1;
  final int limit = 5;

  Future<void> fetchHistory({bool loadMore = false}) async {
    if (isLoading) return;
    if (loadMore && !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final int page = loadMore ? currentPage + 1 : 1;
      final result = await _apiService.fetchHistory(page: page, limit: limit);

      if (result["success"] == true) {
        final data = result["data"];
        final List<dynamic> rawItems = data["items"] ?? [];

        final List<Transaksi> newItems = rawItems
            .map((e) => Transaksi.fromJson(e))
            .toList();

        if (loadMore) {
          transaksi.addAll(newItems);
        } else {
          transaksi = newItems;
        }

        currentPage = page;

        final int totalPages = data["total_pages"] ?? 1;
        hasMore = currentPage < totalPages;

        debugPrint(
          "Page $currentPage fetched: ${newItems.length} items, hasMore: $hasMore",
        );
      } else {
        debugPrint("Error fetchHistory: ${result["message"]}");
      }
    } catch (e) {
      debugPrint("Error fetchHistory: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// dipanggil saat pull-to-refresh
  Future<void> refreshHistory() async {
    currentPage = 1;
    hasMore = true;
    transaksi.clear();
    await fetchHistory();
  }
}
