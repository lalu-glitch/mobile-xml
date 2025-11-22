part of 'websocket_cektransaksi_cubit.dart';

sealed class WebSocketCekTransaksiState extends Equatable {
  const WebSocketCekTransaksiState();

  @override
  List<Object> get props => [];
}

final class WebSocketCekTransaksiInitial extends WebSocketCekTransaksiState {}

final class WebSocketCekTransaksiLoading extends WebSocketCekTransaksiState {}

final class WebSocketCekTransaksiSuccess extends WebSocketCekTransaksiState {
  final CekTransaksiModel data;
  const WebSocketCekTransaksiSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class WebSocketCekTransaksiError extends WebSocketCekTransaksiState {
  final String message;
  const WebSocketCekTransaksiError(this.message);

  @override
  List<Object> get props => [message];
}
