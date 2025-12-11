part of 'mitra_stats_cubit.dart';

sealed class MitraStatsState extends Equatable {
  const MitraStatsState();

  @override
  List<Object> get props => [];
}

final class MitraStatsInitial extends MitraStatsState {}

final class MitraStatsLoading extends MitraStatsState {}

final class MitraStatsLoaded extends MitraStatsState {
  final MitraStatsModel stats;

  const MitraStatsLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

final class MitraStatsError extends MitraStatsState {
  final String message;

  const MitraStatsError(this.message);

  @override
  List<Object> get props => [message];
}
