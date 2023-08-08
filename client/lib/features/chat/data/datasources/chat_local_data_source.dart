// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/core/error/exception.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../common/entity/message.dart';
import '../../../../common/model/message_model.dart';
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
  final DatabaseHelper databaseHelper;
  ChatLocalDataSource({
    required this.databaseHelper,
  });
  @override
  Future<void> cacheFriend(String username) async {
    try {
      if (!await databaseHelper.isUserCached(username)) {
        await databaseHelper.insertAuserToDB(username);
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
      var re = await databaseHelper.fetchUsersFromDB(userName: userName);
      if (re.isNotEmpty) {
        var messages =
            await databaseHelper.fetchAllMessageFromAChat(re[0]['id']);
        Message lastMessage =
            MessageModel.fromMap(messages.elementAt(messages.length - 1));

        var usere = UserModel.fromMap(re[0], lastMessage);
        usere.setLastSeenMessage(lastMessage.id as int);
        await databaseHelper.updateDBColumn(
          tableName: "recent_chats",
          object: UserModel.fromUser(usere).toMap(),
          id: re[0]['id'],
        );
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<Message> fetchLocalMessage(int id) async {
    try {
      return await databaseHelper.fetchLocalMessage(id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Message> cacheMessage(Message message, String to) async {
    try {
      var re = await databaseHelper.fetchUsersFromDB(userName: to);
      UserModel user = UserModel.fromMap(re[0], message);
      message.setChatId(user.id);
      var messageId = await databaseHelper.insertAMessageToDB(message);
      user.setLastMessageId(messageId);

      user.setLastSeenMessage(messageId);
      await databaseHelper.updateDBColumn(
        tableName: "recent_chats",
        object: user.toMap(),
        id: user.id,
      );

      return message;
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<List<Message>> showCachedMessages(String to) async {
    try {
      var userMapList = await databaseHelper.fetchUsersFromDB(userName: to);
      if (userMapList.isNotEmpty) {
        var messages = await databaseHelper
            .fetchAllMessageFromAChat(userMapList[0]['id'] as int);
        return messages.map((i) => MessageModel.fromMap(i)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }
}
