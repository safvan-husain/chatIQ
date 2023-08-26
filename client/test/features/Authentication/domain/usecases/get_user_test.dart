import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:client/features/Authentication/domain/usecases/get_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cache_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUser getUser;
  late MockUserRepository mockUserRepository;
  setUp(() {
    mockUserRepository = MockUserRepository();
    getUser = GetUser(repository: mockUserRepository);
  });
  test(
    'should get user when GetUser is called',
    () async {
      User user = const User(
        username: 'safvan',
        email: 'safvan@gmail.com',
        token: '',
      );
      when(mockUserRepository.getUser(user.username, user.email))
          .thenAnswer((realInvocation) async => Right(user));
      var result = await getUser(GetUserParams(
        username: user.username,
        password: user.email,
      ));
      expect(result, Right(user));
      verify(mockUserRepository.getUser(user.username, user.email));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
