import 'dart:developer';

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
  Future<List<User>> getChats();

  /// remove [User] from cache
  Future<bool> logOut();

  ///wanna cache a message to the storage? perfect!
  ///
  ///for victory [bool], but be redy to catch throwned [CacheException]
  Future<NewMessages> cacheMessage(Message message, String from);
}

Future<Message> fetchLocalMessage(int id) async {
  DatabaseHelper databaseHelper = Injection.injector.get();
  var re = await databaseHelper.db
      .rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
  return MessageModel.fromMap(re[0]);
}

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  @override
  Future<List<User>> getChats() async {
    DatabaseHelper databaseHelper = Injection.injector.get();
    List<User> res = [];
    try {
      List<dynamic> usersMap =
          await databaseHelper.db.rawQuery("SELECT * FROM recent_chats");
      if (usersMap.isNotEmpty) {
        for (var i in usersMap) {
          log('$i');
          var lastMessage = await fetchLocalMessage(i['last_message']);
          print(lastMessage.content);
          var us = UserModel.fromMap(i, lastMessage);
          res.add(us);
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
      DatabaseHelper databaseHelper = Injection.injector.get();
      var re = await databaseHelper.db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$from'");
      UserModel user = UserModel.fromMap(re[0], message);
      message.setChatId(user.id);
      var messageId = await databaseHelper.db.insert(
        'messages',
        MessageModel.fromMessage(message).toMap(),
      );
      List messages = await databaseHelper.db
          .rawQuery("SELECT * FROM messages WHERE chat_id = ?", [user.id]);
      if (user.lastSeenMessageId == null) {
        log({"chatId": user.id, 'new': messages.length}.toString());
        return NewMessages(chatId: user.id, messageCount: messages.length);
      }
      bool istrue = false;
      int newMessagesCount = messages
              .where((e) {
                if (e['id'] == user.lastSeenMessageId) {
                  istrue = true;
                }
                return istrue;
              })
              .toList()
              .length -
          1;
      user.setLastMessageId(messageId);
      await databaseHelper.db.update("recent_chats", user.toMap(),
          where: "id = ?", whereArgs: [user.id]);
      log({
        "chatId": user.id,
        'new': newMessagesCount,
        "last": user.lastSeenMessageId
      }.toString());
      return NewMessages(chatId: user.id, messageCount: newMessagesCount);
    } catch (e) {
      throw CacheException();
    }
  }
}
