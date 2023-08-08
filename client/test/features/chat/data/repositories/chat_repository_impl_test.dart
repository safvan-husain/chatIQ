import 'package:client/common/entity/message.dart';
import 'package:client/core/error/exception.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generate.mocks.dart';

void main() {
  late ChatRepository chatRepository;
  late MockChatLocalDataSource localDataSource;
  late MockChatRemoteDataSource remoteDataSource;
  late MockMessage mockMessage;
  setUp(() {
    localDataSource = MockChatLocalDataSource();
    remoteDataSource = MockChatRemoteDataSource();
    chatRepository = ChatRepositoryImpl(
        localDataSource: localDataSource, remoteDataSource: remoteDataSource);
    mockMessage = MockMessage();
  });
  group(
    'when sendMessage called',
    () {
      late Either<Failure, Message> actual;
      test(
        'should return message for success',
        () async {
          when(localDataSource.cacheFriend(any))
              .thenAnswer((realInvocation) async => mockMessage);
          when(remoteDataSource.sendMessage(any, any, any))
              .thenAnswer((realInvocation) async => true);
          when(localDataSource.cacheMessage(any, any))
              .thenAnswer((realInvocation) async => mockMessage);
          actual = await chatRepository.sendMessage(mockMessage, '', '');
          expect(actual, Right(mockMessage));
        },
      );
      test(
        'should return failure for failed operation',
        () async {
          when(localDataSource.cacheFriend(any))
              .thenAnswer((realInvocation) async => throw CacheException());
          when(remoteDataSource.sendMessage(any, any, any))
              .thenAnswer((realInvocation) async => true);
          when(localDataSource.cacheMessage(any, any))
              .thenAnswer((realInvocation) async => mockMessage);
          actual = await chatRepository.sendMessage(mockMessage, '', '');
          expect(actual.isLeft(), true);
        },
      );
      test(
        'should call  cacheFriend, cacheMessage',
        () async {
          when(localDataSource.cacheFriend(any))
              .thenAnswer((realInvocation) async => mockMessage);
          when(remoteDataSource.sendMessage(any, any, any))
              .thenAnswer((realInvocation) async => true);
          when(localDataSource.cacheMessage(any, any))
              .thenAnswer((realInvocation) async => mockMessage);
          actual = await chatRepository.sendMessage(mockMessage, '', '');
          verify(localDataSource.cacheFriend(any)).called(1);
          verify(localDataSource.cacheMessage(any, any)).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        'should call remote sendMessage',
        () async {
          when(localDataSource.cacheFriend(any))
              .thenAnswer((realInvocation) async => mockMessage);
          when(remoteDataSource.sendMessage(any, any, any))
              .thenAnswer((realInvocation) async => true);
          when(localDataSource.cacheMessage(any, any))
              .thenAnswer((realInvocation) async => mockMessage);
          actual = await chatRepository.sendMessage(mockMessage, '', '');
          verify(remoteDataSource.sendMessage(any, any, any)).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );
  group(
    'when showMessages called',
    () {
      test(
        'should call showCachedMessages for exception should return failure',
        () async {
          when(localDataSource.showCachedMessages(any))
              .thenAnswer((realInvocation) async => throw CacheException());
          var people = await chatRepository.showMessages('');
          expect(people, isA<Left<Failure, List<Message>>>());
          verify(localDataSource.showCachedMessages(any)).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        'should call showCachedMessages and should return list ',
        () async {
          when(localDataSource.showCachedMessages(any))
              .thenAnswer((realInvocation) async => []);
          var people = await chatRepository.showMessages('');
          expect(people.isRight(), true);
          verify(localDataSource.showCachedMessages(any)).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
    },
  );
  group(
    'when updateLasVisit called',
    () {
      test(
        'should call updateLastVisit for exception should return failure',
        () async {
          when(localDataSource.updateLastVisit(any))
              .thenAnswer((realInvocation) async => throw CacheException());
          var people = await chatRepository.updateLasVisit('');
          expect(people, isA<Left<Failure, void>>());
          verify(localDataSource.updateLastVisit(any)).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        'should call updateLastVisit ',
        () async {
          await chatRepository.updateLasVisit('');
          verify(localDataSource.updateLastVisit(any)).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
    },
  );
}
