import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/transaksi/websocket_transaksi.dart';
import '../../../data/services/websocket_service.dart';

part 'websocket_transaksi_state.dart';

class _TrxStatus {
  static const List<int> menunggu = [0, 1, 2, 4];
  static const int sukses = 20;
  static const List<int> gagal = [40, 43, 45, 47, 50, 52, 53, 55, 56, 58];
}
// -------------------------

class WebsocketTransaksiCubit extends Cubit<WebsocketTransaksiState> {
  final WebSocketService webSocketService;
  StreamSubscription? _subscription;

  int _pendingCount = 0;
  static const int maxPending = 6;

  WebsocketTransaksiCubit(this.webSocketService)
    : super(WebsocketTransaksiInitial());

  // ------------------------------
  // START TRANSAKSI
  // ------------------------------
  Future<void> startTransaksi(
    String nomor,
    String kodeProduk, {
    int nominal = 0,
    String endUser = '',
  }) async {
    // Reset state & pending count
    reset();
    emit(WebSocketTransaksiLoading());

    // Pastikan tidak ada koneksi dan listener lama
    await disconnect();

    try {
      // Connect WebSocket
      await webSocketService.connect();

      // Setup listener baru
      _subscription = webSocketService.stream.listen(
        (message) => _handleIncomingMessage(message),
        onError: (error) async {
          emit(WebSocketTransaksiError("Terjadi kesalahan: $error"));
          await disconnect();
        },
        onDone: () async {
          await disconnect();
          log('[WS CLOSED]');
        },
      );
    } catch (e) {
      emit(WebSocketTransaksiError('Gagal terhubung ke server: $e'));
      return;
    }

    // Kirim request setelah listener siap
    webSocketService.sendTransaction(nomor, kodeProduk, nominal, endUser);
  }

  // ------------------------------
  // HANDLE MESSAGE
  // ------------------------------
  Future<void> _handleIncomingMessage(String message) async {
    log('[WS MESSAGE] $message');

    final decoded = jsonDecode(message);
    log('[DECODED MESSAGE SUCCESS] ${decoded['success']}');
    log('[DECODED MESSAGE ERROR] ${decoded['error']}');
    // Jika server kirim error model lama
    if (decoded['success'] == false && decoded['error'] != null) {
      emit(WebSocketTransaksiError(decoded['error']));
      await disconnect();
      return;
    }

    final response = TransaksiResponse.fromJson(decoded);
    final status = response.statusTrx;

    log('[WS STATUS] $status');

    // =========================
    // STATUS MENUNGGU
    // =========================
    if (_TrxStatus.menunggu.contains(status)) {
      _pendingCount++;
      log('[WS PENDING COUNT] $_pendingCount');

      if (_pendingCount >= maxPending) {
        emit(WebSocketTransaksiFailed(response));
        await disconnect();
        return;
      }

      emit(WebSocketTransaksiPending(response));
      return;
    }

    // =========================
    // STATUS SUKSES
    // =========================
    if (status == _TrxStatus.sukses) {
      emit(WebSocketTransaksiSuccess(response));
      await disconnect();
      return;
    }

    // =========================
    // STATUS GAGAL
    // =========================
    if (_TrxStatus.gagal.contains(status)) {
      emit(WebSocketTransaksiFailed(response));
      await disconnect();
      return;
    }

    // =========================
    // FALLBACK - STATUS UNKNOWN
    // =========================
    emit(WebSocketTransaksiFailed(response));
    await disconnect();
    return;
  }

  // ------------------------------
  // DISCONNECT
  // ------------------------------
  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;

    webSocketService.disconnect();
  }

  // Cleanup Cubit
  @override
  Future<void> close() async {
    await disconnect();
    return super.close();
  }

  // Reset ulang cubit
  void reset() {
    _pendingCount = 0;
    emit(WebsocketTransaksiInitial());
  }
}
