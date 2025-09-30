part of 'topup_dummy_speedcash_cubit.dart';

@immutable
sealed class TopupDummySpeedcashState {}

final class TopupDummySpeedcashInitial extends TopupDummySpeedcashState {}

final class TopupDummySpeedcashLoading extends TopupDummySpeedcashState {}

final class TopupDummySpeedcashLoaded extends TopupDummySpeedcashState {
  final TopupModelDummy data;

  TopupDummySpeedcashLoaded(this.data);
}

final class TopupDummySpeedcashError extends TopupDummySpeedcashState {
  final String errMessage;

  TopupDummySpeedcashError(this.errMessage);
}
