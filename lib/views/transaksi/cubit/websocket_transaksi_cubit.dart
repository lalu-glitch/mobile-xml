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
  static const int maxPending = 10;
  WebsocketTransaksiCubit(this.webSocketService)
    : super(WebsocketTransaksiInitial());

  Future<void> startTransaksi(
    String nomor,
    String kodeProduk, {
    int nominal = 0,
    String endUser = '',
  }) async {
    emit(WebSocketTransaksiLoading());

    _pendingCount = 0;
    try {
      await webSocketService.connect();
      if (_subscription != null) return; // udah connected
      _subscription = webSocketService.stream.listen(
        (message) async {
          log('[WS MESSAGE] $message');
          final decoded = jsonDecode(message);

          // jika server kirim error format lama
          if (decoded['success'] == false && decoded['error'] != null) {
            emit(WebSocketTransaksiError(decoded['error']));
            await disconnect(); // tutup koneksi saat error final
            return;
          }

          final response = TransaksiResponse.fromJson(decoded);
          final status = response.statusTrx;

          log('[WS STATUS] $status');

          if (_TrxStatus.menunggu.contains(status)) {
            _pendingCount++;
            log('[WS PENDING COUNT] $_pendingCount');
            if (_pendingCount >= maxPending) {
              emit(WebSocketTransaksiFailed(response));
              await disconnect();
              return;
            }
            // Status menunggu: tetap listening, emit pending
            emit(WebSocketTransaksiPending(response));
          } else if (status == _TrxStatus.sukses) {
            // Status sukses: emit success dan tutup koneksi
            emit(WebSocketTransaksiSuccess(response));
            await disconnect();
          } else if (_TrxStatus.gagal.contains(status)) {
            // Status gagal: emit error dan tutup koneksi
            emit(WebSocketTransaksiFailed(response));
            await disconnect();
          } else {
            // fallback untuk status tak dikenal
            emit(WebSocketTransaksiPending(response));
          }
        },
        onError: (error) async {
          emit(WebSocketTransaksiError("Terjadi kesalahan: $error"));
          await disconnect();
        },
        onDone: () {
          log('[WS CLOSED]');
        },
      );
    } catch (e) {
      emit(
        WebSocketTransaksiError('Gagal terhubung ke server: ${e.toString()}'),
      );
    }
    // Kirim data setelah koneksi dan listener siap
    webSocketService.sendTransaction(nomor, kodeProduk, nominal, endUser);
  }

  /// Tutup koneksi WebSocket secara manual
  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null; // Reset subscription
    webSocketService.disconnect();
  }

  /// Disconnect & cleanup
  @override
  Future<void> close() async {
    await _subscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }

  void reset() {
    emit(WebsocketTransaksiInitial());
    _pendingCount = 0;
  }
}
