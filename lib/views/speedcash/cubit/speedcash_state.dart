part of 'speedcash_cubit.dart';

@immutable
sealed class SpeedcashState {}

final class SpeedcashInitial extends SpeedcashState {}

final class UnbindLoading extends SpeedcashState {}

final class UnbindSuccess extends SpeedcashState {
  final String message;

  UnbindSuccess(this.message);
}

final class UnbindError extends SpeedcashState {
  final String message;

  UnbindError(this.message);
}
