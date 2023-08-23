import 'package:client/core/error/failure.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/usecases/get_cache_user.dart';
import 'package:client/features/Authentication/domain/usecases/get_user.dart';
import 'package:client/features/Authentication/domain/usecases/login_with_google.dart';
import 'package:client/features/Authentication/domain/usecases/register_user.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks([GetUser, RegisterUser, GetCachedUser, LoginWithGoogle])
void main() {
  late AuthenticationCubit cubit;
  late MockGetUser mockGetUser;
  late MockRegisterUser mockRegisterUser;
  late MockGetCachedUser mockGetCachedUser;
  late MockLoginWithGoogle mockLoginWithGoogle;

  User user = const User(username: '', email: '', token: '');
  setUp(() {
    mockGetCachedUser = MockGetCachedUser();
    mockGetUser = MockGetUser();
    mockRegisterUser = MockRegisterUser();
    mockLoginWithGoogle = MockLoginWithGoogle();

    cubit = AuthenticationCubit(
      getUser: mockGetUser,
      registerUser: mockRegisterUser,
      getCachedUser: mockGetCachedUser,
      loginWithGoogle: mockLoginWithGoogle,
    );
  });
  test(
    'initial state should be AuthenticationInitial',
    () {
      expect(cubit.state.authState, AuthState.initial);
    },
  );
  test(
    ' state should be AuthenticationSuccess when success on method loginWithGoogle',
    () async {
      when(mockLoginWithGoogle.call(any)).thenAnswer((_) async => Right(user));
      await cubit.loginWithGoogle('',(){});
      expect(
          cubit.state,
          AuthenticationSuccess(
            authState: AuthState.authenticated,
            user: user,
          ));
      verify(mockLoginWithGoogle.call(any)).called(1);
      verifyNoMoreInteractions(mockLoginWithGoogle);
    },
  );

  test(
    ' state should be AuthenticationFailure when failed on method loginWithGoogle',
    () async {
      when(mockLoginWithGoogle.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      await cubit.loginWithGoogle('',(){});
      expect(cubit.state.authState, AuthState.unauthenticated);
      verify(mockLoginWithGoogle.call(any)).called(1);
      verifyNoMoreInteractions(mockLoginWithGoogle);
    },
  );
  test(
    ' state should be AuthenticationSuccess when success on method getUser',
    () async {
      when(mockGetUser.call(any)).thenAnswer((_) async => Right(user));
      await cubit.getUser('', '',(){});
      expect(
        cubit.state,
        AuthenticationSuccess(authState: AuthState.authenticated, user: user),
      );
      verify(mockGetUser.call(any)).called(1);
      verifyNoMoreInteractions(mockGetUser);
    },
  );
  test(
    ' state should be AuthenticationFailure when failed on method getUser',
    () async {
      when(mockGetUser.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      await cubit.getUser('', '',(){});
      expect(cubit.state.authState, AuthState.unauthenticated);
      verify(mockGetUser.call(any)).called(1);
      verifyNoMoreInteractions(mockGetUser);
    },
  );
  test(
    ' state should be AuthenticationSuccess when success on method getCachedUser',
    () async {
      when(mockGetCachedUser.call(any)).thenAnswer((_) async => Right(user));
      await cubit.getCachedUser((){});
      expect(
        cubit.state,
        AuthenticationSuccess(authState: AuthState.authenticated, user: user),
      );
      verify(mockGetCachedUser.call(any)).called(1);
      verifyNoMoreInteractions(mockGetCachedUser);
    },
  );
  test(
    ' state should be AuthenticationFailure when failed on method getCachedUser',
    () async {
      when(mockGetCachedUser.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      await cubit.getCachedUser((){});
      expect(cubit.state.authState, AuthState.unauthenticated);
      verify(mockGetCachedUser.call(any)).called(1);
      verifyNoMoreInteractions(mockGetCachedUser);
    },
  );
  test(
    ' state should be AuthenticationSuccess when success on method registerUser',
    () async {
      when(mockRegisterUser.call(any)).thenAnswer((_) async => Right(user));
      await cubit.registerUser('', '', '');
      expect(
        cubit.state,
        AuthenticationSuccess(authState: AuthState.authenticated, user: user),
      );
      verify(mockRegisterUser.call(any)).called(1);
      verifyNoMoreInteractions(mockRegisterUser);
    },
  );
  test(
    ' state should be AuthenticationFailure when failed on method registerUser',
    () async {
      when(mockRegisterUser.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      await cubit.registerUser('', '', '');
      expect(cubit.state.authState, AuthState.unauthenticated);
      verify(mockRegisterUser.call(any)).called(1);
      verifyNoMoreInteractions(mockRegisterUser);
    },
  );
}
