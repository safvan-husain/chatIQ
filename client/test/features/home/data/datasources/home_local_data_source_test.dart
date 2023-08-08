import 'package:client/common/entity/message.dart';
import 'package:client/core/helper/database/data_base_helper.dart';
import 'package:client/features/home/data/datasources/home_local_data_source.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_local_data_source_test.mocks.dart';

@GenerateMocks([DatabaseHelper, SharedPreferences, Message])
void main() {
  late HomeLocalDataSource homeLocalDataSource;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockMessage message;
  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    homeLocalDataSource =
        HomeLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
    message = MockMessage();
  });
  test(
    'should call fetchUsersFromDB when getChats called and should retun a list',
    () async {
      when(mockDatabaseHelper.fetchUsersFromDB())
          .thenAnswer((realInvocation) async => []);
      var result = await homeLocalDataSource.getChats();
      expect(result, []);
      verify(mockDatabaseHelper.fetchUsersFromDB()).called(1);
      verifyNoMoreInteractions(mockDatabaseHelper);
    },
  );
  group('when cache message', () {
    test(
      'should call fetchUsersFromDB to store last message id',
      () async {
        when(mockDatabaseHelper.fetchUsersFromDB())
            .thenAnswer((realInvocation) async => []);
        await homeLocalDataSource.cacheMessage(message, '');
        verify(mockDatabaseHelper.fetchUsersFromDB()).called(1);
        // verifyNoMoreInteractions(mockDatabaseHelper);
      },
    );
    test(
      'should call insertAMessageToDB',
      () async {
        when(mockDatabaseHelper.fetchUsersFromDB())
            .thenAnswer((realInvocation) async => []);
        await homeLocalDataSource.cacheMessage(message, '');
        verify(mockDatabaseHelper.insertAMessageToDB(message)).called(1);
        // verifyNoMoreInteractions(mockDatabaseHelper);
      },
    );
    test(
      'should call updateDBColumn',
      () async {
        when(mockDatabaseHelper.fetchUsersFromDB())
            .thenAnswer((realInvocation) async => []);
        await homeLocalDataSource.cacheMessage(message, '');
        verify(mockDatabaseHelper.updateDBColumn(
          tableName: any,
          object: any,
          id: any,
        )).called(1);
        // verifyNoMoreInteractions(mockDatabaseHelper);
      },
    );
  });
  test(
    'should call isUserCached, insertAuserToDB when cacheFriend called',
    () async {
      when(mockDatabaseHelper.isUserCached(any))
          .thenAnswer((realInvocation) async => true);
      await homeLocalDataSource.cacheFriend('');
      verify(mockDatabaseHelper.isUserCached(any)).called(1);
      verify(mockDatabaseHelper.insertAuserToDB(any)).called(1);
      verifyNoMoreInteractions(mockDatabaseHelper);
    },
  );
  group('when cacheFriend called', () {
    test(
      'should call insertAMessageToDB',
      () async {
        when(mockDatabaseHelper.fetchUsersFromDB())
            .thenAnswer((realInvocation) async => []);
        await homeLocalDataSource.cacheMessage(message, '');
        verify(mockDatabaseHelper.insertAMessageToDB(message)).called(1);
        // verifyNoMoreInteractions(mockDatabaseHelper);
      },
    );
    test(
      'should call updateDBColumn',
      () async {
        when(mockDatabaseHelper.fetchUsersFromDB())
            .thenAnswer((realInvocation) async => []);
        await homeLocalDataSource.cacheMessage(message, '');
        verify(mockDatabaseHelper.updateDBColumn(
          tableName: any,
          object: any,
          id: any,
        )).called(1);
        // verifyNoMoreInteractions(mockDatabaseHelper);
      },
    );
  });
}
