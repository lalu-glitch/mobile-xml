part of 'request_topup_cubit.dart';

@immutable
sealed class RequestTopUpState {}

final class RequestTopUpInitial extends RequestTopUpState {}

final class RequestTopUpLoading extends RequestTopUpState {}

final class RequestTopUpSuccess extends RequestTopUpState {
  final RequestTopUpModel data;
  RequestTopUpSuccess(this.data);
}

final class RequestTopUpError extends RequestTopUpState {
  final String message;
  RequestTopUpError(this.message);
}
