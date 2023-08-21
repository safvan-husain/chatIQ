// Mocks generated by Mockito 5.4.0 from annotations
// in client/test/features/chat/generate.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:client/common/entity/message.dart' as _i4;
import 'package:client/core/error/failure.dart' as _i8;
import 'package:client/core/helper/database/data_base_helper.dart' as _i5;
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart'
    as _i9;
import 'package:client/features/chat/data/datasources/chat_remote_data_source.dart'
    as _i10;
import 'package:client/features/chat/domain/repositories/chat_repository.dart'
    as _i6;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite/sqflite.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabase_1 extends _i1.SmartFake implements _i3.Database {
  _FakeDatabase_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMessage_2 extends _i1.SmartFake implements _i4.Message {
  _FakeMessage_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_3 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabaseHelper_4 extends _i1.SmartFake
    implements _i5.DatabaseHelper {
  _FakeDatabaseHelper_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ChatRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRepository extends _i1.Mock implements _i6.ChatRepository {
  MockChatRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i4.Message>>> showMessages(
          String? chatId) =>
      (super.noSuchMethod(
        Invocation.method(
          #showMessages,
          [chatId],
        ),
        returnValue:
            _i7.Future<_i2.Either<_i8.Failure, List<_i4.Message>>>.value(
                _FakeEither_0<_i8.Failure, List<_i4.Message>>(
          this,
          Invocation.method(
            #showMessages,
            [chatId],
          ),
        )),
      ) as _i7.Future<_i2.Either<_i8.Failure, List<_i4.Message>>>);
  @override
  _i7.Future<_i2.Either<_i8.Failure, void>> updateLasVisit(String? userName) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLasVisit,
          [userName],
        ),
        returnValue: _i7.Future<_i2.Either<_i8.Failure, void>>.value(
            _FakeEither_0<_i8.Failure, void>(
          this,
          Invocation.method(
            #updateLasVisit,
            [userName],
          ),
        )),
      ) as _i7.Future<_i2.Either<_i8.Failure, void>>);
  @override
  _i7.Future<_i2.Either<_i8.Failure, _i4.Message>> sendMessage(
    _i4.Message? message,
    String? myid,
    String? to,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendMessage,
          [
            message,
            myid,
            to,
          ],
        ),
        returnValue: _i7.Future<_i2.Either<_i8.Failure, _i4.Message>>.value(
            _FakeEither_0<_i8.Failure, _i4.Message>(
          this,
          Invocation.method(
            #sendMessage,
            [
              message,
              myid,
              to,
            ],
          ),
        )),
      ) as _i7.Future<_i2.Either<_i8.Failure, _i4.Message>>);
}

/// A class which mocks [DatabaseHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseHelper extends _i1.Mock implements _i5.DatabaseHelper {
  MockDatabaseHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Database get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeDatabase_1(
          this,
          Invocation.getter(#db),
        ),
      ) as _i3.Database);
  @override
  _i7.Future<bool> isUserCached(String? username) => (super.noSuchMethod(
        Invocation.method(
          #isUserCached,
          [username],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<_i4.Message> fetchLocalMessage(int? id) => (super.noSuchMethod(
        Invocation.method(
          #fetchLocalMessage,
          [id],
        ),
        returnValue: _i7.Future<_i4.Message>.value(_FakeMessage_2(
          this,
          Invocation.method(
            #fetchLocalMessage,
            [id],
          ),
        )),
      ) as _i7.Future<_i4.Message>);
  @override
  _i7.Future<void> updateDBColumn({
    required String? tableName,
    required Map<String, dynamic>? object,
    required int? id,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDBColumn,
          [],
          {
            #tableName: tableName,
            #object: object,
            #id: id,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<int> insertAMessageToDB(_i4.Message? message) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertAMessageToDB,
          [message],
        ),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<int> insertAuserToDB(String? username) => (super.noSuchMethod(
        Invocation.method(
          #insertAuserToDB,
          [username],
        ),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<_i4.Message?> fetchLastMessageFromAChat(int? chatId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchLastMessageFromAChat,
          [chatId],
        ),
        returnValue: _i7.Future<_i4.Message?>.value(),
      ) as _i7.Future<_i4.Message?>);
  @override
  _i7.Future<List<dynamic>> fetchAllMessageFromAChat(int? chatId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAllMessageFromAChat,
          [chatId],
        ),
        returnValue: _i7.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i7.Future<List<dynamic>>);
  @override
  _i7.Future<List<Map<String, dynamic>>> fetchUsersFromDB({
    String? userName,
    int? id,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUsersFromDB,
          [],
          {
            #userName: userName,
            #id: id,
          },
        ),
        returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i7.Future<List<Map<String, dynamic>>>);
}

/// A class which mocks [Message].
///
/// See the documentation for Mockito's code generation for more information.
class MockMessage extends _i1.Mock implements _i4.Message {
  MockMessage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set chatId(int? _chatId) => super.noSuchMethod(
        Invocation.setter(
          #chatId,
          _chatId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set id(int? _id) => super.noSuchMethod(
        Invocation.setter(
          #id,
          _id,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get content => (super.noSuchMethod(
        Invocation.getter(#content),
        returnValue: '',
      ) as String);
  @override
  bool get isme => (super.noSuchMethod(
        Invocation.getter(#isme),
        returnValue: false,
      ) as bool);
  @override
  set isme(bool? _isme) => super.noSuchMethod(
        Invocation.setter(
          #isme,
          _isme,
        ),
        returnValueForMissingStub: null,
      );
  @override
  DateTime get time => (super.noSuchMethod(
        Invocation.getter(#time),
        returnValue: _FakeDateTime_3(
          this,
          Invocation.getter(#time),
        ),
      ) as DateTime);
  @override
  set time(DateTime? _time) => super.noSuchMethod(
        Invocation.setter(
          #time,
          _time,
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic setChatId(int? id) => super.noSuchMethod(Invocation.method(
        #setChatId,
        [id],
      ));
}

/// A class which mocks [ChatLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatLocalDataSource extends _i1.Mock
    implements _i9.ChatLocalDataSource {
  MockChatLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.DatabaseHelper get databaseHelper => (super.noSuchMethod(
        Invocation.getter(#databaseHelper),
        returnValue: _FakeDatabaseHelper_4(
          this,
          Invocation.getter(#databaseHelper),
        ),
      ) as _i5.DatabaseHelper);
  @override
  _i7.Future<void> cacheFriend(String? username) => (super.noSuchMethod(
        Invocation.method(
          #cacheFriend,
          [username],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> updateLastVisit(String? userName) => (super.noSuchMethod(
        Invocation.method(
          #updateLastVisit,
          [userName],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<_i4.Message> fetchLocalMessage(int? id) => (super.noSuchMethod(
        Invocation.method(
          #fetchLocalMessage,
          [id],
        ),
        returnValue: _i7.Future<_i4.Message>.value(_FakeMessage_2(
          this,
          Invocation.method(
            #fetchLocalMessage,
            [id],
          ),
        )),
      ) as _i7.Future<_i4.Message>);
  @override
  _i7.Future<_i4.Message> cacheMessage(
    _i4.Message? message,
    String? to,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheMessage,
          [
            message,
            to,
          ],
        ),
        returnValue: _i7.Future<_i4.Message>.value(_FakeMessage_2(
          this,
          Invocation.method(
            #cacheMessage,
            [
              message,
              to,
            ],
          ),
        )),
      ) as _i7.Future<_i4.Message>);
  @override
  _i7.Future<List<_i4.Message>> showCachedMessages(String? to) =>
      (super.noSuchMethod(
        Invocation.method(
          #showCachedMessages,
          [to],
        ),
        returnValue: _i7.Future<List<_i4.Message>>.value(<_i4.Message>[]),
      ) as _i7.Future<List<_i4.Message>>);
}

/// A class which mocks [ChatRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRemoteDataSource extends _i1.Mock
    implements _i10.ChatRemoteDataSource {
  MockChatRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<bool> sendMessage(
    _i4.Message? message,
    String? myid,
    String? to,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendMessage,
          [
            message,
            myid,
            to,
          ],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
}
