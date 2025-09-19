import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../data/models/transaksi/transaksi_response.dart';
import '../data/models/transaksi/status_transaksi.dart';
import '../data/services/api_service.dart';

class TransaksiViewModel extends ChangeNotifier {
  final ApiService apiService;

  bool isLoading = false;
  String? error;
  TransaksiResponse? transaksiResponse;
  StatusTransaksi? statusTransaksi;
  Timer? _debounce;
  final logger = Logger();

  TransaksiViewModel({ApiService? service})
    : apiService = service ?? ApiService();

  /// Proses transaksi dengan delay debounce
  void prosesTransaksiDebounce(
    String nomor,
    String kodeProduk,
    String kodeDompet,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      prosesTransaksi(nomor, kodeProduk, kodeDompet);
    });
  }

  /// Proses transaksi satu kali
  Future<void> prosesTransaksi(
    String nomor,
    String kodeProduk,
    String kodeDompet,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await apiService.prosesTransaksi(
        nomor,
        kodeProduk,
        kodeDompet,
      );

      if (result["success"] == true && result["data"] != null) {
        transaksiResponse = result["data"] as TransaksiResponse;
        if (transaksiResponse?.kodeInbox != null) {
          // cek status transaksi sekali
          // kasih delay 1 detik sebelum cek status
          await Future.delayed(const Duration(seconds: 3));
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
  Future<void> cekStatusTransaksi({
    int retryCount = 0,
    int maxRetry = 10,
  }) async {
    final kodeInbox = transaksiResponse?.kodeInbox;
    if (kodeInbox == null) {
      error = "Kode Inbox tidak ditemukan. Transaksi belum dimulai.";
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final result = await apiService.getStatusByInbox(kodeInbox);

      if (result['success'] == true) {
        final data = result['data'];
        if (data is StatusTransaksi) {
          statusTransaksi = data;
        } else if (data is Map<String, dynamic>) {
          statusTransaksi = StatusTransaksi.fromJson(data);
        } else {
          throw Exception("Format data tidak dikenali");
        }

        // Jika status_trx masih 1 atau 2, coba lagi setelah 1 detik
        if (statusTransaksi?.statusTrx == 1 ||
            statusTransaksi?.statusTrx == 2) {
          if (retryCount < maxRetry) {
            await Future.delayed(const Duration(seconds: 1));
            await cekStatusTransaksi(
              retryCount: retryCount + 1,
              maxRetry: maxRetry,
            );
            return;
          } else {
            error =
                "Status masih ${statusTransaksi?.keterangan} setelah $maxRetry percobaan";
          }
        }

        error = null; // sukses dan status final
      } else {
        error =
            result['message']?.toString() ?? "Gagal mengambil status transaksi";
      }
    } catch (e) {
      error = "Gagal mengambil status transaksi: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
