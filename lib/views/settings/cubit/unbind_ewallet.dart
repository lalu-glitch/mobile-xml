part of 'unbind_ewallet_cubit.dart';

abstract class EwalletState {}

class EwalletInitial extends EwalletState {}

class UnbindLoading extends EwalletState {
  final String kodeDompet;
  UnbindLoading(this.kodeDompet);
}

class UnbindSuccess extends EwalletState {
  final String message;
  final String kodeDompet;
  UnbindSuccess(this.message, this.kodeDompet);
}

class UnbindError extends EwalletState {
  final String message;
  final String kodeDompet;
  UnbindError(this.message, this.kodeDompet);
}
