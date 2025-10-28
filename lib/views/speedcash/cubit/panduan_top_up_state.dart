part of 'panduan_top_up_cubit.dart';

@immutable
sealed class PanduanTopUpState {}

final class PanduanTopUpInitial extends PanduanTopUpState {}

final class PanduanTopUpLoading extends PanduanTopUpState {}

final class PanduanTopUpLoaded extends PanduanTopUpState {
  final GuideTopUpModel data;

  PanduanTopUpLoaded(this.data);
}

final class PanduanTopError extends PanduanTopUpState {
  final String message;
  PanduanTopError(this.message);
}
