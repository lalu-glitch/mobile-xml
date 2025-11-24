part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> data;
  const RegisterSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);
  @override
  List<Object> get props => [message];
}
