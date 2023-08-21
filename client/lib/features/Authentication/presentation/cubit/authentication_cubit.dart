import 'package:bloc/bloc.dart';
import 'package:client/features/Authentication/domain/usecases/get_cache_user.dart';
import 'package:client/features/Authentication/domain/usecases/get_user.dart';
import 'package:client/features/Authentication/domain/usecases/register_user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_with_google.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late GetUser _getUser;
  late RegisterUser _registerUser;
  late GetCachedUser _getCachedUser;
  late LoginWithGoogle _loginWithGoogle;

  AuthenticationCubit({
    required GetUser getUser,
    required RegisterUser registerUser,
    required GetCachedUser getCachedUser,
    required LoginWithGoogle loginWithGoogle,
  }) : super(const AuthenticationInitial(authState: AuthState.initial)) {
    _getUser = getUser;
    _registerUser = registerUser;
    _getCachedUser = getCachedUser;
    _loginWithGoogle = loginWithGoogle;
  }
  Future<void> loginWithGoogle(
      String email, void Function() onNewMessageCachingComplete) async {
    var result = await _loginWithGoogle.call(LoginWithGoogleParams(
      email: email,
      onNewMessageCachingComplete: onNewMessageCachingComplete,
    ));
    result.fold(
      (failure) {
        emit(AuthenticationFailure(
          authState: AuthState.unauthenticated,
          failure: failure,
          time: DateTime.now(),
        ));
      },
      (user) {
        emit(AuthenticationSuccess(
          authState: AuthState.authenticated,
          user: user,
        ));
      },
    );
  }

  Future<void> getUser(String email, String password,
      void Function() onNewMessageCachingComplete) async {
    Either<Failure, User> result = await _getUser(GetUserParams(
      username: email,
      password: password,
      onNewMessageCachingComplete: onNewMessageCachingComplete,
    ));
    result.fold(
      (failure) {
        emit(
          AuthenticationFailure(
              authState: AuthState.unauthenticated,
              failure: failure,
              time: DateTime.now()),
        );
      },
      (user) {
        emit(
          AuthenticationSuccess(authState: AuthState.authenticated, user: user),
        );
      },
    );
  }

  Future<void> getCachedUser(
      void Function() onNewMessageCachingComplete) async {
    Either<Failure, User> result =
        await _getCachedUser(GetCachedUserParams(onNewMessageCachingComplete));
    result.fold(
      (failure) {
        emit(AuthenticationFailure(
          authState: AuthState.unauthenticated,
          failure: failure,
          time: DateTime.now(),
        ));
      },
      (user) {
        emit(
          AuthenticationSuccess(authState: AuthState.authenticated, user: user),
        );
      },
    );
  }

  Future<void> registerUser(
      String email, String username, String password) async {
    Either<Failure, User> result = await _registerUser.call(RegisterUserParams(
      email: email,
      username: username,
      password: password,
    ));
    result.fold(
      (failure) {
        emit(
          AuthenticationFailure(
            authState: AuthState.unauthenticated,
            failure: failure,
            time: DateTime.now(),
          ),
        );
      },
      (user) {
        emit(
          AuthenticationSuccess(authState: AuthState.authenticated, user: user),
        );
      },
    );
  }
}
