part of 'websocket_transaksi_cubit.dart';

@immutable
sealed class WebsocketTransaksiState {}

final class WebsocketTransaksiInitial extends WebsocketTransaksiState {}

final class WebSocketTransaksiLoading extends WebsocketTransaksiState {}

final class WebSocketTransaksiPending extends WebsocketTransaksiState {
  final TransaksiResponse data;
  WebSocketTransaksiPending(this.data);
}

final class WebSocketTransaksiSuccess extends WebsocketTransaksiState {
  final TransaksiResponse data;

  WebSocketTransaksiSuccess(this.data);
}

final class WebSocketTransaksiFailed extends WebsocketTransaksiState {
  final TransaksiResponse data;
  WebSocketTransaksiFailed(this.data);
}

final class WebSocketTransaksiError extends WebsocketTransaksiState {
  final String message;
  WebSocketTransaksiError(this.message);
}
