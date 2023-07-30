import 'package:client/common/entity/message.dart';
import 'package:client/common/model/message_model.dart';
import 'package:client/core/error/exception.dart';
import 'package:client/features/home/data/models/user_model.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/database/data_base_helper.dart';

abstract class HomeLocalDataSource {
  ///get all account[User] that user chatted with
  ///
  ///throw [CacheException] if no cache data is present
  Future<List<NewMessages>> getChats();

  /// remove [User] from cache
  Future<bool> logOut();

  ///wanna cache a message to the storage? perfect!
  ///
  ///for victory [bool], but be redy to catch throwned [CacheException]
  Future<NewMessages> cacheMessage(Message message, String from);
}

DatabaseHelper databaseHelper = Injection.injector.get();

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  @override
  Future<List<NewMessages>> getChats() async {
    List<NewMessages> res = [];
    try {
      List<dynamic> usersMap = await _fetchUsersFromDB();
      if (usersMap.isNotEmpty) {
        //adding all users with corresponding last message
        for (var i in usersMap) {
          print(i);
          int lastMessageId = i['last_message'];
          Message lastMessage = await fetchLocalMessage(lastMessageId);
          User us = UserModel.fromMap(i, lastMessage);
          int messageCount = await _findNewMessageCount(user: us);
          res.add(NewMessages(user: us, messageCount: messageCount));
        }
      }
      return res;
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return await sharedPreferences.setString('user', '');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NewMessages> cacheMessage(Message message, String from) async {
    try {
      var userMap = await _fetchUsersFromDB(userName: from);
      UserModel user = UserModel.fromMap(userMap[0], message);
      message.setChatId(user.id);
      var messageId = await _insertAMessageToDB(message);

      int newMessagesCount = await _findNewMessageCount(user: user);
      user.setLastMessageId(messageId);
      updateDBColumn(
        tableName: 'recent_chats',
        object: user.toMap(),
        id: user.id,
      );

      return NewMessages(user: user, messageCount: newMessagesCount);
    } catch (e) {
      throw CacheException();
    }
  }
}

///get message by its id from local DB [messages] table
///
Future<Message> fetchLocalMessage(int id) async {
  var re = await databaseHelper.db
      .rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
  return MessageModel.fromMap(re[0]);
}

Future<void> updateDBColumn(
    {required String tableName,
    required Map<String, dynamic> object,
    required int id}) async {
  await databaseHelper.db
      .update("recent_chats", object, where: "id = ?", whereArgs: [id]);
}

Future<int> _findNewMessageCount({required User user}) async {
  bool istrue = false;

  var messages = await _fetchAllMessageFromAChat(user.id);
  if (user.lastSeenMessageId == null) {
    return messages.length;
  }
  return messages
          .where((e) {
            if (e['id'] == user.lastSeenMessageId) {
              istrue = true;
            }
            return istrue;
          })
          .toList()
          .length -
      1;
}

Future<List<dynamic>> _fetchAllMessageFromAChat(int chatId) async {
  return await databaseHelper.db
      .rawQuery("SELECT * FROM messages WHERE chat_id = ?", [chatId]);
}

///query list of users from table [recent_chats] using id or username
///
///if no argument is passed, it will query all user
///
Future<List<Map<String, dynamic>>> _fetchUsersFromDB(
    {String? userName, int? id}) async {
  if (userName != null) {
    return await databaseHelper.db
        .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$userName'");
  }
  if (id != null) {
    return await databaseHelper.db
        .rawQuery("SELECT * FROM recent_chats WHERE id = '$id'");
  }
  return await databaseHelper.db.rawQuery("SELECT * FROM recent_chats");
}

Future<int> _insertAMessageToDB(Message message) async {
  return await databaseHelper.db.insert(
    'messages',
    MessageModel.fromMessage(message).toMap(),
  );
}
