part of 'daftar_mitra_cubit.dart';

sealed class DaftarMitraState extends Equatable {
  const DaftarMitraState();

  @override
  List<Object> get props => [];
}

final class DaftarMitraInitial extends DaftarMitraState {}

final class DaftarMitraLoading extends DaftarMitraState {}

final class DaftarMitraSuccess extends DaftarMitraState {
  final String responseMessage;

  const DaftarMitraSuccess(this.responseMessage);

  @override
  List<Object> get props => [responseMessage];
}

final class DaftarMitraError extends DaftarMitraState {
  final String message;

  const DaftarMitraError(this.message);

  @override
  List<Object> get props => [message];
}
