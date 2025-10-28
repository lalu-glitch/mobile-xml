part of 'list_bank_cubit.dart';

@immutable
sealed class SpeedcashBankState {}

final class SpeedcashBankInitial extends SpeedcashBankState {}

final class SpeedcashBankLoading extends SpeedcashBankState {}

final class SpeedcashBankLoaded extends SpeedcashBankState {
  final DataBank dataBank;

  SpeedcashBankLoaded(this.dataBank);
}

final class SpeedcashBankError extends SpeedcashBankState {
  final String message;
  SpeedcashBankError(this.message);
}
