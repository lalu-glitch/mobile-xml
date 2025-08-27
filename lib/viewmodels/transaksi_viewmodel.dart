import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/transaksi_response.dart';
import '../models/status_transaksi.dart';
import '../services/api_service.dart';

class TransaksiViewModel extends ChangeNotifier {
  final ApiService apiService;

  bool isLoading = false;
  String? error;
  TransaksiResponse? transaksiResponse;
  StatusTransaksi? statusTransaksi;
  Timer? _debounce;

  TransaksiViewModel({ApiService? service})
    : apiService = service ?? ApiService();

  /// Proses transaksi dengan delay debounce
  void prosesTransaksiDebounce(String nomor, String kodeProduk) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      prosesTransaksi(nomor, kodeProduk);
    });
  }

  /// Proses transaksi satu kali
  Future<void> prosesTransaksi(String nomor, String kodeProduk) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await apiService.prosesTransaksi(nomor, kodeProduk);

      if (result["success"] == true && result["data"] != null) {
        transaksiResponse = result["data"] as TransaksiResponse;
        if (transaksiResponse?.kodeInbox != null) {
          // cek status transaksi sekali
          await cekStatusTransaksi();
        } else {
          isLoading = false;
          error = "Kode Inbox tidak tersedia";
          notifyListeners();
        }
      } else {
        isLoading = false;
        error = result["message"] ?? "Gagal memulai transaksi";
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  /// Cek status transaksi sekali
  Future<void> cekStatusTransaksi() async {
    final kodeInbox = transaksiResponse?.kodeInbox;
    if (kodeInbox == null) {
      error = "Kode Inbox tidak ditemukan. Transaksi belum dimulai.";
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final result = await apiService.getStatusByInbox(kodeInbox);

      // Periksa apakah ada nested "data"
      final dataMap = result['data'] ?? result;

      statusTransaksi = StatusTransaksi.fromJson(dataMap);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = "Gagal mengambil status transaksi: $e";
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
