part of 'info_akun_cubit.dart';

@immutable
sealed class InfoAkunState {}

final class InfoAkunInitial extends InfoAkunState {}

final class InfoAkunLoading extends InfoAkunInitial {}

final class InfoAkunLoaded extends InfoAkunInitial {
  final InfoAkunModel data;
  InfoAkunLoaded(this.data);
}

final class InfoAkunError extends InfoAkunInitial {
  final String message;

  InfoAkunError(this.message);
}
