part of 'provider_noprefix_cubit.dart';

@immutable
sealed class ProviderState {}

class ProviderInitial extends ProviderState {}

class ProviderNoPrefixLoading extends ProviderState {}

class ProviderNoPrefixSuccess extends ProviderState {
  final List<ProviderKartu> providers;

  ProviderNoPrefixSuccess(this.providers);
}

class ProviderNoPrefixError extends ProviderState {
  final String message;

  ProviderNoPrefixError(this.message);
}
