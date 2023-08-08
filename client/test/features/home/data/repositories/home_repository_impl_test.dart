import 'package:client/common/entity/message.dart';
import 'package:client/core/error/exception.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/features/home/data/datasources/home_local_data_source.dart';
import 'package:client/features/home/data/datasources/home_remote_data_source.dart';
import 'package:client/features/home/data/repositories/home_repository_impl.dart';
import 'package:client/features/home/domain/entities/contact.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/platform/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks(
    [HomeLocalDataSource, HomeRemoteDataSource, Message, NewMessages])
void main() {
  late MockHomeLocalDataSource mockHomeLocalDataSource;
  late MockHomeRemoteDataSource mockHomeRemoteDataSource;
  late HomeRepository homeRepository;
  late NetworkInfo networkInfo;
  late MockMessage mockMessage;

  setUp(() {
    mockHomeLocalDataSource = MockHomeLocalDataSource();
    mockHomeRemoteDataSource = MockHomeRemoteDataSource();
    networkInfo = NetworkInfo(isConnected: Future.value(true));
    mockMessage = MockMessage();
    homeRepository = HomeRepositoryImpl(
      networkInfo: networkInfo,
      localDataSource: mockHomeLocalDataSource,
      remoteDataSource: mockHomeRemoteDataSource,
    );
  });
  test(
    'should call remoteDataSource getAllPeople when repository getAllPeople is called and should return a list',
    () async {
      when(mockHomeRemoteDataSource.getAllPeople(
              token: captureAnyNamed('token')))
          .thenAnswer((realInvocation) async => []);
      var people = await homeRepository.getAllPeople(token: '');
      expect(people.isRight(), true);
      verify(mockHomeRemoteDataSource.getAllPeople(
              token: captureAnyNamed('token')))
          .called(1);
      verifyNoMoreInteractions(mockHomeRemoteDataSource);
    },
  );
  test(
    'should return failure when remote getAllPeople is failer',
    () async {
      when(mockHomeRemoteDataSource.getAllPeople(
              token: captureAnyNamed('token')))
          .thenAnswer((realInvocation) async => throw ServerException());
      var people = await homeRepository.getAllPeople(token: '');
      expect(people, isA<Left<Failure, List<Contact>>>());
      verify(mockHomeRemoteDataSource.getAllPeople(
              token: captureAnyNamed('token')))
          .called(1);
      verifyNoMoreInteractions(mockHomeRemoteDataSource);
    },
  );
  test(
    'should call logOut when repository logOut is called',
    () async {
      when(mockHomeLocalDataSource.logOut())
          .thenAnswer((realInvocation) async => true);
      var people = await homeRepository.logOut();
      expect(people, const Right(true));
      verify(mockHomeLocalDataSource.logOut()).called(1);
      verifyNoMoreInteractions(mockHomeLocalDataSource);
    },
  );
  test(
    'should return failure when local logout is failer',
    () async {
      when(mockHomeLocalDataSource.logOut())
          .thenAnswer((realInvocation) async => throw CacheException());
      var people = await homeRepository.logOut();
      expect(people, isA<Left<Failure, bool>>());
      verify(mockHomeLocalDataSource.logOut()).called(1);
      verifyNoMoreInteractions(mockHomeLocalDataSource);
    },
  );
  test(
    'should call localDataSource.getChats when repository getLocalChats is called',
    () async {
      when(mockHomeLocalDataSource.getChats())
          .thenAnswer((realInvocation) async => []);
      var people = await homeRepository.getLocalChats();
      expect(people.isRight(), true);
      verify(mockHomeLocalDataSource.getChats()).called(1);
      verifyNoMoreInteractions(mockHomeLocalDataSource);
    },
  );
  test(
    'should return failure when local getLocalChats is failer',
    () async {
      when(mockHomeLocalDataSource.getChats())
          .thenAnswer((realInvocation) async => throw CacheException());
      var people = await homeRepository.getLocalChats();
      expect(people, isA<Left<Failure, List<NewMessages>>>());
      verify(mockHomeLocalDataSource.getChats()).called(1);
      verifyNoMoreInteractions(mockHomeLocalDataSource);
    },
  );
  test(
    'should call localDataSource.cacheFriend when repository cacheMessage is called',
    () async {
      when(mockHomeLocalDataSource.cacheMessage(any, any))
          .thenAnswer((realInvocation) async => MockNewMessages());
      var people = await homeRepository.cacheMessage(mockMessage, '');
      expect(people.isRight(), true);
      verify(mockHomeLocalDataSource.cacheFriend(any)).called(1);
    },
  );
  test(
    'should call localDataSource.cacheMessage when repository cacheMessage is called',
    () async {
      when(mockHomeLocalDataSource.cacheMessage(any, any))
          .thenAnswer((realInvocation) async => MockNewMessages());
      var people = await homeRepository.cacheMessage(mockMessage, '');
      expect(people.isRight(), true);
      verify(mockHomeLocalDataSource.cacheMessage(any, any)).called(1);
    },
  );
  test(
    'should return failure when localDataSource.cacheMessage is failed',
    () async {
      when(mockHomeLocalDataSource.cacheMessage(any, any))
          .thenAnswer((realInvocation) async => throw CacheException());
      var people = await homeRepository.cacheMessage(mockMessage, '');
      expect(people.isLeft(), true);
      verify(mockHomeLocalDataSource.cacheMessage(any, any)).called(1);
    },
  );
}
