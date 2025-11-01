part of 'request_kode_agen_cubit.dart';

@immutable
sealed class RequestKodeAgenState {}

final class RequestKodeAgenInitial extends RequestKodeAgenState {}

final class RequestKodeAgenLoading extends RequestKodeAgenState {}

final class RequestKodeAgenLoaded extends RequestKodeAgenState {
  final Map<String, dynamic> data;

  RequestKodeAgenLoaded(this.data);
}

final class RequestKodeAgenError extends RequestKodeAgenState {
  final String message;

  RequestKodeAgenError(this.message);
}
