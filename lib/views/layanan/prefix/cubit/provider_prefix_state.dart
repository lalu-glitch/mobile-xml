part of 'provider_prefix_cubit.dart';

@immutable
sealed class ProviderPrefixState {}

final class ProviderPrefixInitial extends ProviderPrefixState {}

class ProviderPrefixLoading extends ProviderPrefixState {}

class ProviderPrefixSuccess extends ProviderPrefixState {
  final List<Provider> providers;

  ProviderPrefixSuccess(this.providers);
}

class ProviderPrefixError extends ProviderPrefixState {
  final String message;

  ProviderPrefixError(this.message);
}
