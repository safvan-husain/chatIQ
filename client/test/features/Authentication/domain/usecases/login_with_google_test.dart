import 'package:client/core/error/failure.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:client/features/Authentication/domain/usecases/login_with_google.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_with_google_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late LoginWithGoogle loginWithGoogle;
  late MockUserRepository mockUserRepository;
  late User user;
  setUp(() {
    mockUserRepository = MockUserRepository();
    loginWithGoogle = LoginWithGoogle(userRepository: mockUserRepository);
    user = const User(
      username: 'safvan',
      email: 'safvan@gmail.com',
      token: '',
    );
  });
  test(
    'should return a user for success',
    () async {
      when(mockUserRepository.loginUsingGoogle('safvan@gmail.com'))
          .thenAnswer((realInvocation) async => Right(user));
      Either<Failure, User> result = await loginWithGoogle
          .call(LoginWithGoogleParams(email: 'safvan@gmail.com'));
      expect(result, Right(user));
      verify(mockUserRepository.loginUsingGoogle('safvan@gmail.com'));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
