import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:client/features/Authentication/domain/usecases/register_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late RegisterUser registerUser;
  late MockUserRepository mockUserRepository;
  late User user;
  setUp(() {
    mockUserRepository = MockUserRepository();
    registerUser = RegisterUser(authenticationRepository: mockUserRepository);
    user = const User(username: '', email: '', token: '');
  });
  test(
    'should return a user for success',
    () async {
      when(mockUserRepository.registerUser('', '', ''))
          .thenAnswer((realInvocation) async => Right(user));
      var result = await registerUser
          .call(RegisterUserParams(email: '', password: '', username: ''));
      expect(result, Right(user));
      verify(mockUserRepository.registerUser('', '', ''));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
