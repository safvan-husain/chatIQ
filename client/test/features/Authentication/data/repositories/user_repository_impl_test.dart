import 'package:client/features/Authentication/data/datasources/user_local_data_source.dart';
import 'package:client/features/Authentication/data/datasources/user_remote_data_source.dart';
import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:client/features/Authentication/data/repositories/user_repository_impl.dart';
import 'package:client/platform/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserLocalDataSource, UserRemoteDataSource, NetworkInfo])
void main() {
  late UserRepositoryImpl userRepositoryImpl;
  late MockUserLocalDataSource mockUserLocalDataSource;
  late MockUserRemoteDataSource mockUserRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late UserModel user;
  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockUserLocalDataSource = MockUserLocalDataSource();
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    userRepositoryImpl = UserRepositoryImpl(
        localDataSource: mockUserLocalDataSource,
        remoteDataSource: mockUserRemoteDataSource,
        networkInfo: mockNetworkInfo);
    user = const UserModel(username: '', email: '', token: '');
  });
  test(
    'shold return a user when getUser called',
    () async {
      when(mockUserRemoteDataSource.getUser('', ''))
          .thenAnswer((realInvocation) async => user);
      var result = await userRepositoryImpl.getUser('', '',(){});
      expect(result, Right(user));
      verify(mockUserRemoteDataSource.getUser('', ''));
      verify(mockUserLocalDataSource.cacheUser(user));
      verifyNoMoreInteractions(mockUserRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
    },
  );
  test(
    'shold return a user when registerUser called',
    () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockUserRemoteDataSource.registerUser('', '', ''))
          .thenAnswer((realInvocation) async => user);
      var result = await userRepositoryImpl.registerUser('', '', '');
      expect(result, Right(user));
      verify(mockUserRemoteDataSource.registerUser('', '', ''));
      verify(mockUserLocalDataSource.cacheUser(user));
      verifyNoMoreInteractions(mockUserRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
    },
  );
  test(
    'shold return a user when getCachedUser called',
    () async {
      when(mockUserLocalDataSource.getUser())
          .thenAnswer((realInvocation) async => user);
      var result = await userRepositoryImpl.getCachedUser((){});
      expect(result, Right(user));
      verify(mockUserLocalDataSource.getUser());
      verifyNoMoreInteractions(mockUserLocalDataSource);
    },
  );
  test(
    'shold return a user when LoginUsingGoogle called',
    () async {
      when(mockUserRemoteDataSource.getUserWithGoogle(''))
          .thenAnswer((realInvocation) async => user);
      var result = await userRepositoryImpl.loginUsingGoogle('',(){});
      expect(result, Right(user));
      verify(mockUserRemoteDataSource.getUserWithGoogle(''));
      verify(mockUserLocalDataSource.cacheUser(user));
      verifyNoMoreInteractions(mockUserRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
    },
  );
}
