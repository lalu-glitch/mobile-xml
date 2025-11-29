import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/transaksi/cek_transaksi_model.dart';
import '../../../../data/services/websocket_service.dart';

part 'websocket_cektransaksi_state.dart';

class WebSocketCekTransaksiCubit extends Cubit<WebSocketCekTransaksiState> {
  final WebSocketService webSocketService;
  StreamSubscription? _subscription;
  WebSocketCekTransaksiCubit(this.webSocketService)
    : super(WebSocketCekTransaksiInitial());

  Future<void> cekTransaksi(String nomor, String kodeProduk) async {
    emit(WebSocketCekTransaksiLoading());

    try {
      await webSocketService.connect();

      await _subscription?.cancel();

      final completer = Completer();

      _subscription = webSocketService.stream.listen(
        (raw) {
          final msg = jsonDecode(raw);
          log('$msg');
          // HANDLE ERROR
          if (msg['success'] == false) {
            emit(
              WebSocketCekTransaksiError(msg['message'] ?? 'Terjadi kesalahan'),
            );
            if (!completer.isCompleted) completer.complete();
            return;
          }

          // HANDLE SUCCESS
          final data = CekTransaksiModel.fromJson(msg['data']);
          emit(WebSocketCekTransaksiSuccess(data));
          if (!completer.isCompleted) completer.complete();
        },
        onError: (e) {
          emit(WebSocketCekTransaksiError(e.toString()));
          if (!completer.isCompleted) completer.complete();
        },
      );

      webSocketService.cekTransaksi(nomor, kodeProduk);

      // TUNGGU 1 RESPON SAJA
      await completer.future;
    } catch (e) {
      emit(WebSocketCekTransaksiError("WS gagal: $e"));
    } finally {
      await disconnect();
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    webSocketService.disconnect();
  }

  void reset() {
    disconnect();
    emit(WebSocketCekTransaksiInitial());
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }
}
