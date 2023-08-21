import 'package:client/core/error/failure.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:client/features/Authentication/domain/usecases/get_cache_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cache_user_test.mocks.dart';

// class ockUserRepository extends Mock implements UserRepository {}

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;
  late GetCachedUser getCachedUser;
  setUp(() {
    mockUserRepository = MockUserRepository();
    getCachedUser = GetCachedUser(repository: mockUserRepository);
  });

  test(
    'should get cached user',
    () async {
      User cachedUser = const User(
        username: 'safvan',
        email: 'safvan@gmail.com',
        token: '',
      );
      when(mockUserRepository.getCachedUser((){}))
          .thenAnswer((realInvocation) async => Right(cachedUser));
      final result = await getCachedUser(GetCachedUserParams((){}));
      expect(result, Right(cachedUser));
      verify(mockUserRepository.getCachedUser((){}));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
  test(
    'should get CacheFailure if user is null or empty in the cache',
    () async {
      Failure failure = CacheFailure();
      when(mockUserRepository.getCachedUser((){}))
          .thenAnswer((realInvocation) async => Left(failure));
      final result = await getCachedUser(GetCachedUserParams((){}));
      expect(result, Left(failure));
      verify(mockUserRepository.getCachedUser((){}));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
