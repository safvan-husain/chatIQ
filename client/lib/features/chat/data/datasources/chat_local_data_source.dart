import 'dart:developer';

import 'package:client/core/error/exception.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../common/entity/message.dart';
import '../../../../common/model/message_model.dart';
import '../../../../core/Injector/injector.dart';
import '../../../../core/helper/database/data_base_helper.dart';
import '../../../home/data/models/user_model.dart';

abstract class ChatLocalData {
  ///cache the [User] if not alredy cached
  Future<void> cacheFriend(String username);
  Future<void> updateLastVisit(String userName);
  Future<Message> cacheMessage(Message message, String to);
  Future<List<Message>> showCachedMessages(String to);
}

class ChatLocalDataSource extends ChatLocalData {
  DatabaseHelper databaseHelper = Injection.injector.get();
  @override
  Future<void> cacheFriend(String username) async {
    try {
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$username'");
      if (re.isEmpty) {
        await databaseHelper.db.insert('recent_chats', {'user_name': username});
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

//onlyidnedd for argument refactor note f
  @override
  Future<void> updateLastVisit(String userName) async {
    try {
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$userName'");
      if (re.isNotEmpty) {
        var messages = await databaseHelper.db.rawQuery(
            "SELECT * FROM messages WHERE chat_id = '${re[0]['id']}'");
        Message lastMessage =
            MessageModel.fromMap(messages.elementAt(messages.length - 1));

        var usere = UserModel.fromMap(re[0], lastMessage);
        usere.setLastSeenMessage(lastMessage.id as int);
        await databaseHelper.db.update(
            "recent_chats", UserModel.fromUser(usere).toMap(),
            where: "id = ?", whereArgs: [re[0]['id']]);
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<Message> fetchLocalMessage(int id) async {
    var re = await databaseHelper.db
        .rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
    return MessageModel.fromMap(re[0]);
  }

  @override
  Future<Message> cacheMessage(Message message, String to) async {
    try {
      var re = await _fetchUsersFromDB(userName: to);
      print(re);
      UserModel user = UserModel.fromMap(re[0], message);
      message.setChatId(user.id);
      var messageId = await _insertAMessageToDB(message);
      user.setLastMessageId(messageId);

      user.setLastSeenMessage(messageId);
      print(user.toMap());
      await _updateDBColumn(
          id: user.id, tableName: "recent_chats", object: user.toMap());
      print(await _fetchUsersFromDB(id: user.id));
      // List<Map<String, dynamic>> usersMap =await fetchUsersFromDB();
      // if (usersMap.isNotEmpty) {
      //   for (var i in usersMap) {
      //     print(
      //       '${i}',
      //     );
      //   }
      // }
      return message;
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<List<Message>> showCachedMessages(String to) async {
    try {
      var userMapList = await _fetchUsersFromDB(userName: to);
      if (userMapList.isNotEmpty) {
        var messages =
            await _fetchAllMessageFromAChat(userMapList[0]['id'] as int);
        return messages.map((i) => MessageModel.fromMap(i)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<int> _insertAMessageToDB(Message message) async {
    return await databaseHelper.db.insert(
      'messages',
      MessageModel.fromMessage(message).toMap(),
    );
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

  Future<void> _updateDBColumn(
      {required String tableName,
      required Map<String, dynamic> object,
      required int id}) async {
    await databaseHelper.db
        .update("recent_chats", object, where: "id = ?", whereArgs: [id]);
  }
}
