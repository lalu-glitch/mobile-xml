part of 'speedcash_register_cubit.dart';

sealed class SpeedcashRegisterState extends Equatable {
  const SpeedcashRegisterState();

  @override
  List<Object> get props => [];
}

final class SpeedcashRegisterInitial extends SpeedcashRegisterState {}

final class SpeedcashRegisterLoading extends SpeedcashRegisterState {}

final class SpeedcashRegisterSuccess extends SpeedcashRegisterState {
  final SpeedcashRegisterModel data;
  const SpeedcashRegisterSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class SpeedcashRegisterError extends SpeedcashRegisterState {
  final String message;
  const SpeedcashRegisterError(this.message);

  @override
  List<Object> get props => [message];
}
