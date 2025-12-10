part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authfinish extends AuthState {
  final UserModel user;
  const Authfinish(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthFailure extends AuthState {
  final String messgae;

  const AuthFailure({required this.messgae});
  @override
  List<Object> get props => [messgae];
}
