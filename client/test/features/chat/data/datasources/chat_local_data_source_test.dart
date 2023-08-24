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
    'when updateLastVisit called',
    () {
      test(
        'should call fetchUsersFromDB',
        () async {
          when(mockDataBaseHelper.getOrInsertUserFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async =>
                  {"id": 1, "user_name": "user", "last_seen_message": 1});
          await chatLocalDataSource.updateLastVisit('');
          verify(mockDataBaseHelper.getOrInsertUserFromDB(
              userName: captureAnyNamed('userName')));
        },
      );
      test(
        'should call  fetchAllMessageFromAChat if the user is not empty',
        () async {
          when(mockDataBaseHelper.getOrInsertUserFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async =>
                  {"id": 1, "user_name": "user", "last_seen_message": 1});
          when(mockDataBaseHelper.fetchAllMessageFromAChat(any))
              .thenAnswer((realInvocation) async => [
                    {"id": 1, ...mockMessage.toMap()}
                  ]);
          await chatLocalDataSource.updateLastVisit('');
          verify(mockDataBaseHelper.getOrInsertUserFromDB(
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
          when(mockDataBaseHelper.getOrInsertUserFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async =>
                  {"id": 1, "user_name": "user", "last_seen_message": 1});
          when(mockDataBaseHelper.insertAMessageToDB(any, any))
              .thenAnswer((realInvocation) async => MockNewMessages());
          await chatLocalDataSource.cacheMessage(mockMessage, '');
          verify(mockDataBaseHelper.getOrInsertUserFromDB(
              userName: captureAnyNamed('userName')));
        },
      );
      test(
        'should call  insertAMessageToDB',
        () async {
          when(mockDataBaseHelper.getOrInsertUserFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async =>
                  {"id": 1, "user_name": "user", "last_seen_message": 1});
          when(mockDataBaseHelper.insertAMessageToDB(any, any))
              .thenAnswer((realInvocation) async => MockNewMessages());
          await chatLocalDataSource.cacheMessage(mockMessage, '');
          verify(mockDataBaseHelper.insertAMessageToDB(any, any));
        },
      );
      test(
        'should call  updateDBColumn',
        () async {
          when(mockDataBaseHelper.getOrInsertUserFromDB(
                  userName: captureAnyNamed('userName')))
              .thenAnswer((realInvocation) async =>
                  {"id": 1, "user_name": "user", "last_seen_message": 1});
          when(mockDataBaseHelper.insertAMessageToDB(any, any))
              .thenAnswer((realInvocation) async => MockNewMessages());
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
      when(mockDataBaseHelper.getOrInsertUserFromDB(
              userName: captureAnyNamed('userName')))
          .thenAnswer((realInvocation) async =>
              {"id": 1, "user_name": "user", "last_seen_message": 1});
      when(mockDataBaseHelper.fetchAllMessageFromAChat(any))
          .thenAnswer((realInvocation) async => [
                {"id": 1, ...mockMessage.toMap()}
              ]);
      await chatLocalDataSource.showCachedMessages('');
      verify(mockDataBaseHelper.getOrInsertUserFromDB(
              userName: captureAnyNamed('userName')))
          .called(1);
      verify(mockDataBaseHelper.fetchAllMessageFromAChat(1)).called(1);
      verifyNoMoreInteractions(mockDataBaseHelper);
    },
  );
}
