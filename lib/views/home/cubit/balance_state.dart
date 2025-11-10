part of 'balance_cubit.dart';

sealed class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

final class BalanceInitial extends BalanceState {}

final class BalanceLoading extends BalanceState {}

final class BalanceLoaded extends BalanceState {
  final UserBalance data;
  const BalanceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class BalanceLogout extends BalanceState {
  final String message;

  const BalanceLogout(this.message);

  @override
  List<Object> get props => [message];
}

final class BalanceError extends BalanceState {
  final String message;

  const BalanceError(this.message);

  @override
  List<Object> get props => [message];
}
