part of 'info_akun_cubit.dart';

@immutable
sealed class InfoAkunState {}

final class InfoAkunInitial extends InfoAkunState {}

final class InfoAkunLoading extends InfoAkunInitial {}

final class InfoAkunSuccess extends InfoAkunInitial {
  //sementara pake message aja
  final InfoAkunModel data;
  InfoAkunSuccess(this.data);
}

final class InfoAkunError extends InfoAkunInitial {
  final String message;

  InfoAkunError(this.message);
}
