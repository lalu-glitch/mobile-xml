import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../data/models/transaksi/transaksi_response.dart';
import '../data/models/transaksi/status_transaksi.dart';
import '../data/services/api_service.dart';

class TransaksiViewModel extends ChangeNotifier {
  final ApiService apiService;

  bool _isLoading = false;
  String? _error;
  TransaksiResponse? transaksiResponse;
  StatusTransaksi? _statusTransaksi;
  Timer? _debounce;

  bool get isLoading => _isLoading;
  String? get error => _error;
  StatusTransaksi? get statusTransaksi => _statusTransaksi;

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
    _isLoading = true;
    _error = null;
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
          _isLoading = false;
          _error = "Kode Inbox tidak tersedia";
          notifyListeners();
        }
      } else {
        _isLoading = false;
        _error = result["message"] ?? "Gagal memulai transaksi";
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
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
      _error = "Kode Inbox tidak ditemukan. Transaksi belum dimulai.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final result = await apiService.getStatusByInbox(kodeInbox);

      if (result['success'] == true) {
        final data = result['data'];
        if (data is StatusTransaksi) {
          _statusTransaksi = data;
        } else if (data is Map<String, dynamic>) {
          _statusTransaksi = StatusTransaksi.fromJson(data);
        } else {
          throw Exception("Format data tidak dikenali");
        }

        // Jika status_trx masih 1 atau 2, coba lagi setelah 1 detik
        if (_statusTransaksi?.statusTrx == 1 ||
            _statusTransaksi?.statusTrx == 2) {
          if (retryCount < maxRetry) {
            await Future.delayed(const Duration(seconds: 1));
            await cekStatusTransaksi(
              retryCount: retryCount + 1,
              maxRetry: maxRetry,
            );
            return;
          } else {
            _error =
                "Status masih ${_statusTransaksi?.keterangan} setelah $maxRetry percobaan";
          }
        }

        _error = null; // sukses dan status final
      } else {
        _error =
            result['message']?.toString() ?? "Gagal mengambil status transaksi";
      }
    } catch (e) {
      _error = "Gagal mengambil status transaksi: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method baru: Reset state ke awal
  void reset() {
    _isLoading =
        true; // Mulai dengan loading agar langsung tampil _loadingWidget()
    _error = null;
    _statusTransaksi = null;
    notifyListeners(); // Trigger rebuild dengan state bersih
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
