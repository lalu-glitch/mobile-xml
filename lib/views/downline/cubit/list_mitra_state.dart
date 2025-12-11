part of 'list_mitra_cubit.dart';

sealed class ListMitraState extends Equatable {
  const ListMitraState();

  @override
  List<Object> get props => [];
}

final class ListMitraInitial extends ListMitraState {}

final class ListMitraLoading extends ListMitraState {}

final class ListMitraLoaded extends ListMitraState {
  final List<Mitra> mitraList;

  const ListMitraLoaded(this.mitraList);

  @override
  List<Object> get props => [mitraList];
}

final class ListMitraError extends ListMitraState {
  final String message;

  const ListMitraError(this.message);
  @override
  List<Object> get props => [message];
}
