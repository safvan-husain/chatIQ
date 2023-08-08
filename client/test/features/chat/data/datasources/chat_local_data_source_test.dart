import 'package:client/common/entity/message.dart';
import 'package:client/common/model/message_model.dart';
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generate.mocks.dart';

void main() {
  var mockDataBaseHelper = MockDatabaseHelper();
  MessageModel mockMessage =
      MessageModel(chatId: 1, time: DateTime.now(), isme: false, content: '');
  ChatLocalDataSource chatLocalDataSource =
      ChatLocalDataSource(databaseHelper: mockDataBaseHelper);
  group(
    'when cacheFriend called',
    () {
      test(
        'should call isUserCached',
        () async {
          when(mockDataBaseHelper.isUserCached(any))
              .thenAnswer((realInvocation) async => true);
          when(mockDataBaseHelper.insertAuserToDB(any))
              .thenAnswer((realInvocation) async => 1);
          await chatLocalDataSource.cacheFriend('');
          verify(mockDataBaseHelper.isUserCached(any));
          verifyNoMoreInteractions(mockDataBaseHelper);
        },
      );
      test(
        'should call  insertAuserToDB when the user is not cached',
        () async {
          when(mockDataBaseHelper.isUserCached(any))
              .thenAnswer((realInvocation) async => false);
          when(mockDataBaseHelper.insertAuserToDB(any))
              .thenAnswer((realInvocation) async => 1);
          await chatLocalDataSource.cacheFriend('');
          verify(mockDataBaseHelper.isUserCached(any)).called(1);
          verify(mockDataBaseHelper.insertAuserToDB(any)).called(1);
          verifyNoMoreInteractions(mockDataBaseHelper);
        },
      );
    },
  );
  group(
    'when updateLastVisit called',
    () {
      test(
        'should call fetchUsersFromDB',
        () async {
          when(mockDataBaseHelper.fetchUsersFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async => []);
          await chatLocalDataSource.updateLastVisit('');
          verify(mockDataBaseHelper.fetchUsersFromDB(
              userName: captureAnyNamed('userName')));
        },
      );
      test(
        'should call  fetchAllMessageFromAChat if the user is not empty',
        () async {
          when(mockDataBaseHelper.fetchUsersFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async => [
                    {"id": 1, "user_name": "user", "last_seen_message": 1}
                  ]);
          when(mockDataBaseHelper.fetchAllMessageFromAChat(any))
              .thenAnswer((realInvocation) async => [
                    {"id": 1, ...mockMessage.toMap()}
                  ]);
          await chatLocalDataSource.updateLastVisit('');
          verify(mockDataBaseHelper.fetchUsersFromDB(
              userName: captureAnyNamed('userName')));
        },
      );
    },
  );
  group(
    'when cacheMessage called',
    () {
      test(
        'should call fetchUsersFromDB',
        () async {
          when(mockDataBaseHelper.fetchUsersFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async => [
                    {"id": 1, "user_name": "user", "last_seen_message": 1}
                  ]);
          when(mockDataBaseHelper.insertAMessageToDB(any))
              .thenAnswer((realInvocation) async => 1);
          await chatLocalDataSource.cacheMessage(mockMessage, '');
          verify(mockDataBaseHelper.fetchUsersFromDB(
              userName: captureAnyNamed('userName')));
        },
      );
      test(
        'should call  insertAMessageToDB',
        () async {
          when(mockDataBaseHelper.fetchUsersFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async => [
                    {"id": 1, "user_name": "user", "last_seen_message": 1}
                  ]);
          when(mockDataBaseHelper.insertAMessageToDB(any))
              .thenAnswer((realInvocation) async => 1);
          await chatLocalDataSource.cacheMessage(mockMessage, '');
          verify(mockDataBaseHelper.insertAMessageToDB(any));
        },
      );
      test(
        'should call  updateDBColumn',
        () async {
          when(mockDataBaseHelper.fetchUsersFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async => [
                    {"user_name": "user", "last_seen_message": 2, "id": 1}
                  ]);
          when(mockDataBaseHelper.insertAMessageToDB(any))
              .thenAnswer((realInvocation) async => 1);
          await chatLocalDataSource.cacheMessage(mockMessage, '');
          verify(mockDataBaseHelper.updateDBColumn(
            tableName: captureAnyNamed('tableName'),
            object: captureAnyNamed('object'),
            id: captureAnyNamed('id'),
          ));
        },
      );
    },
  );
  test(
    'shuld call fetchUsersFromDB when showCachedMessages called',
    () async {
      when(mockDataBaseHelper.fetchUsersFromDB(
              userName: captureAnyNamed('userName')))
          .thenAnswer((realInvocation) async => [
                {"user_name": "user", "last_seen_message": 2, "id": 1}
              ]);
      when(mockDataBaseHelper.fetchAllMessageFromAChat(any))
          .thenAnswer((realInvocation) async => [
                {"id": 1, ...mockMessage.toMap()}
              ]);
      await chatLocalDataSource.showCachedMessages('');
      verify(mockDataBaseHelper.fetchUsersFromDB(
              userName: captureAnyNamed('userName')))
          .called(1);
      verify(mockDataBaseHelper.fetchAllMessageFromAChat(1)).called(1);
      verifyNoMoreInteractions(mockDataBaseHelper);
    },
  );
}
