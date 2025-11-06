part of 'unbind_ewallet_cubit.dart';

abstract class EwalletState {}

class EwalletInitial extends EwalletState {}

class UnbindLoading extends EwalletState {
  final String kode;
  UnbindLoading(this.kode);
}

class UnbindSuccess extends EwalletState {
  final String message;
  final String kode;
  UnbindSuccess(this.message, this.kode);
}

class UnbindError extends EwalletState {
  final String message;
  final String kode;
  UnbindError(this.message, this.kode);
}
