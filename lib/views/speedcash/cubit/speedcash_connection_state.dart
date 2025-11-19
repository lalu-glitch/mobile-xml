part of 'speedcash_connection_cubit.dart';

sealed class SpeedcashConnectionState extends Equatable {
  const SpeedcashConnectionState();

  @override
  List<Object> get props => [];
}

final class SpeedcashConnectionInitial extends SpeedcashConnectionState {}

final class SpeedcashConnectionLoading extends SpeedcashConnectionState {}

final class SpeedcashConnectionSuccess extends SpeedcashConnectionState {}

final class SpeedcashConnectionError extends SpeedcashConnectionState {
  final String message;

  const SpeedcashConnectionError(this.message);

  @override
  List<Object> get props => [message];
}
