part of 'authentication_cubit.dart';

enum AuthState { initial, authenticated, unauthenticated }

abstract class AuthenticationState extends Equatable {
  final AuthState authState;
  final User? user;
  final Failure? failure;
  final DateTime? time;

  const AuthenticationState({
    required this.authState,
    this.user,
    this.failure,
    this.time,
  });

  @override
  List<Object?> get props => [authState, user, time];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial({required super.authState});
}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess({
    required super.authState,
    required super.user,
  });
}

class AuthenticationFailure extends AuthenticationState {
  const AuthenticationFailure({
    required super.authState,
    required super.failure,
    required super.time,
  });
}
