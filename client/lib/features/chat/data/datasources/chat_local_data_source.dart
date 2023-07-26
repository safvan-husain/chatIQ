import 'dart:developer';

import 'package:client/core/error/exception.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../common/entity/message.dart';
import '../../../../common/model/message_model.dart';
import '../../../../core/Injector/injector.dart';
import '../../../../core/database/data_base_helper.dart';
import '../../../home/data/models/user_model.dart';

class ChatLocalDataSource {
  DatabaseHelper databaseHelper = Injection.injector.get();

  ///cache the [User] if not alredy cached
  Future<void> cacheFriend(User user) async {
    try {
      Map<String, dynamic> userMap = UserModel.fromUser(user).toMap();
      var re = await databaseHelper.db.rawQuery(
          "SELECT * FROM recent_chats WHERE user_name = '${user.username}'");
      if (re.isEmpty) {
        await databaseHelper.db
            .insert('recent_chats', {'user_name': user.username});
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

//onlyidnedd for argument refactor note f
  Future<void> updateLastVisit(User user) async {
    try {
      var messages = await databaseHelper.db
          .rawQuery("SELECT * FROM messages WHERE chat_id = '${user.id}'");
      Message lastMessage =
          MessageModel.fromMap(messages.elementAt(messages.length - 1));
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE id = '${user.id}'");
      var usere = UserModel.fromMap(re[0], lastMessage);
      usere.setLastSeenMessage(lastMessage.id as int);
      await databaseHelper.db.update(
          "recent_chats", UserModel.fromUser(usere).toMap(),
          where: "id = ?", whereArgs: [user.id]);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<Message> fetchLocalMessage(int id) async {
    DatabaseHelper databaseHelper = Injection.injector.get();
    var re = await databaseHelper.db
        .rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
    return MessageModel.fromMap(re[0]);
  }

  Future<Message> cacheMessage(Message message, String to) async {
    try {
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$to'");
      UserModel user = UserModel.fromMap(re[0], message);
      message.setChatId(user.id);
      var messageId = await databaseHelper.db.insert(
        'messages',
        MessageModel.fromMessage(message).toMap(),
      );
      user.setLastMessageId(messageId);
      log({
        'messageId': user.lastMessage!.id,
        'message': message.content,
      }.toString());
      user.setLastSeenMessage(messageId);
      log(user.toMap().toString());
      await databaseHelper.db.update("recent_chats", user.toMap(),
          where: "id = ?", whereArgs: [user.id]);
      await databaseHelper.db.update("recent_chats", user.toMap(),
          where: "id = ?", whereArgs: [user.id]);
      List<Map<String, dynamic>> usersMap =
          await databaseHelper.db.rawQuery("SELECT * FROM recent_chats");
      if (usersMap.isNotEmpty) {
        for (var i in usersMap) {
          print(
            '${i}',
          );
        }
      }
      return message;
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<List<Message>> showCachedMessages(String to) async {
    try {
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$to'");
      if (re.isNotEmpty) {
        var messages = await databaseHelper.db.rawQuery(
            "SELECT * FROM messages WHERE chat_id = '${re[0]['id']}'");
        print(messages);
        return messages.map((i) => MessageModel.fromMap(i)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }
}
