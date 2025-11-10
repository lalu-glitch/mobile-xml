part of 'layanan_cubit.dart';

sealed class LayananState extends Equatable {
  const LayananState();

  @override
  List<Object> get props => [];
}

final class LayananInitial extends LayananState {}

final class LayananLoading extends LayananState {}

final class LayananLoaded extends LayananState {
  final IconResponse data;

  const LayananLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class LayananError extends LayananState {
  final String message;

  const LayananError(this.message);

  @override
  List<Object> get props => [message];
}
