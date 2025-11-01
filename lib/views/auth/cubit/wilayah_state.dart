part of 'wilayah_cubit.dart';

@immutable
sealed class WilayahState {}

final class WilayahInitial extends WilayahState {}

final class WilayahLoading extends WilayahState {}

final class WilayahLoaded extends WilayahState {
  final List<Region> data;

  WilayahLoaded(this.data);
}

final class WilayahError extends WilayahState {
  final String message;

  WilayahError(this.message);
}
