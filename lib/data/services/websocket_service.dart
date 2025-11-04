import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'auth_service.dart';
import '../../core/helper/constant_finals.dart';

class WebSocketService {
  final AuthService _authService;
  IOWebSocketChannel? _channel;
  bool _isConnected = false;

  WebSocketService(this._authService);

  Future<void> connect() async {
    final token = await _authService.getAccessToken();
    final uri = Uri.parse(webSocketURL);
    log('Connecting ke URI');

    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        headers: {'Authorization': 'Bearer $token'},
      );

      _channel = IOWebSocketChannel(socket);
      _isConnected = true;
      log('WS Connected');
    } catch (e) {
      _isConnected = false;
      log('WS Connection Failed');
      throw Exception(e.toString());
    }
  }

  void sendTransaction(
    String nomor,
    String kodeProduk,
    int? nominal,
    String? endUser,
  ) {
    if (!_isConnected || _channel == null) {
      log('WS not connected');
      return;
    }

    final message = {
      'service': 'transaksi',
      'action': 'transaksi',
      'data': {
        'tujuan': nomor,
        'kode_produk': kodeProduk,
        if (nominal != null) 'nominal': nominal,
        if (endUser != null && endUser.isNotEmpty) 'enduser': endUser,
      },
    };

    log('[WS TX] Kirim payload: $message');
    final encoded = jsonEncode(message);
    _channel!.sink.add(encoded);
    log('[WS TX] Payload dikirim');
  }

  Stream<dynamic> get stream {
    if (_channel == null) {
      throw StateError('WebSocket not connected');
    }
    return _channel!.stream;
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.normalClosure);
      log('[WS] Disconnected');
    }
    _isConnected = false;
  }
}
