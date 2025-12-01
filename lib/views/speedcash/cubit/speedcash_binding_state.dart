part of 'speedcash_binding_cubit.dart';

sealed class SpeedcashBindingState extends Equatable {
  const SpeedcashBindingState();

  @override
  List<Object> get props => [];
}

final class SpeedcashBindingInitial extends SpeedcashBindingState {}

final class SpeedcashBindingLoading extends SpeedcashBindingState {}

final class SpeedcashBindingSuccess extends SpeedcashBindingState {
  final SpeedcashBindingModel data;
  const SpeedcashBindingSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class SpeedcashBindingError extends SpeedcashBindingState {
  final String message;
  const SpeedcashBindingError(this.message);

  @override
  List<Object> get props => [message];
}
