part of 'info_akun_cubit.dart';

@immutable
sealed class InfoAkunState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InfoAkunInitial extends InfoAkunState {}

final class InfoAkunLoading extends InfoAkunState {}

final class InfoAkunLoaded extends InfoAkunState {
  final InfoAkunModel data;
  InfoAkunLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

final class InfoAkunError extends InfoAkunState {
  final String message;

  InfoAkunError(this.message);

  @override
  List<Object?> get props => [message];
}
