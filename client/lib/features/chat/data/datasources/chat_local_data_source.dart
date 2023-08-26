import 'package:client/core/error/exception.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../common/entity/message.dart';
import '../../../../common/model/message_model.dart';
import '../../../../core/helper/database/data_base_helper.dart';
import '../../../home/data/models/user_model.dart';

abstract class ChatLocalData {
  ///cache the [User] if not alredy cached
  Future<void> cacheFriend(String username);

  ///updating last seen message, last message id to the cahed user.
  Future<void> updateLastVisit(String userName);

  ///will update last message id to the cached user.
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
      await databaseHelper.getOrInsertUserFromDB(userName: username);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<void> updateLastVisit(String userName) async {
    try {
      var userMap =
          await databaseHelper.getOrInsertUserFromDB(userName: userName);
      Message? lastMessage =
          await databaseHelper.fetchLastMessageFromAChat(userMap['id']);
      if (lastMessage != null) {
        //updating the user in db with the latest message id, and last seen message id.
        var usere = UserModel.fromMap(userMap, lastMessage);
        usere.setLastSeenMessage(lastMessage.id as int);
        await databaseHelper.updateDBColumn(
          tableName: "recent_chats",
          object: UserModel.fromUser(usere).toMap(),
          id: userMap['id'],
        );
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  Future<Message> fetchLocalMessage(int id) async {
    try {
      return await databaseHelper.getMessageWithId(id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Message> cacheMessage(Message message, String to) async {
    try {
      await databaseHelper.insertAMessageToDB(message, to);
      return message;
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<List<Message>> showCachedMessages(String to) async {
    try {
      var userMap = await databaseHelper.getOrInsertUserFromDB(userName: to);
      var messages =
          await databaseHelper.fetchAllMessageFromAChat(userMap['id'] as int);
      return messages.map((i) => MessageModel.fromMap(i)).toList();
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }
}
