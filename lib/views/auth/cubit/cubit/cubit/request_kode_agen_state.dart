part of 'request_kode_agen_cubit.dart';

sealed class ReqKodeAgenState {}

final class ReqKodeAgenInitial extends ReqKodeAgenState {}

final class ReqKodeAgenLoading extends ReqKodeAgenState {}

final class ReqKodeAgenLoaded extends ReqKodeAgenState {
  final Map<String, dynamic> data;

  ReqKodeAgenLoaded(this.data);
}

final class ReqKodeAgenError extends ReqKodeAgenState {
  final String message;

  ReqKodeAgenError(this.message);
}
