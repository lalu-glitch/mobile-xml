part of 'promo_cubit.dart';

sealed class PromoState extends Equatable {
  const PromoState();

  @override
  List<Object> get props => [];
}

final class PromoInitial extends PromoState {}

final class PromoLoading extends PromoState {}

final class PromoLoaded extends PromoState {
  final IconResponse data;

  const PromoLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class PromoError extends PromoState {
  final String message;

  const PromoError(this.message);

  @override
  List<Object> get props => [message];
}
