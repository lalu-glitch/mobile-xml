part of 'edit_info_akun_cubit.dart';

@immutable
sealed class EditInfoAkunState {}

final class EditInfoAkunInitial extends EditInfoAkunState {}

final class EditInfoAkunLoading extends EditInfoAkunState {}

final class EditInfoAkunSuccess extends EditInfoAkunState {
  final UserEditModel data;
  EditInfoAkunSuccess(this.data);
}

final class EditInfoAkunError extends EditInfoAkunState {
  final String message;
  EditInfoAkunError(this.message);
}
