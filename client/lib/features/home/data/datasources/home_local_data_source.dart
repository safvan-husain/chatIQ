// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/constance/color_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/common/entity/message.dart';
import 'package:client/core/error/exception.dart';
import 'package:client/features/home/data/models/user_model.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';

import '../../../../core/helper/database/data_base_helper.dart';

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
  Future<void> cacheFriend(String username);
}

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  final DatabaseHelper databaseHelper;
  HomeLocalDataSourceImpl({
    required this.databaseHelper,
  });
  @override
  Future<List<NewMessages>> getChats() async {
    List<NewMessages> res = [];
    try {
      List<dynamic> usersMap = await databaseHelper.fetchUsersFromDB();
      if (usersMap.isNotEmpty) {
        //adding all users with corresponding last message
        for (var i in usersMap) {
          print(i);
          int lastMessageId = i['last_message'];
          Message lastMessage =
              await databaseHelper.fetchLocalMessage(lastMessageId);
          User us = UserModel.fromMap(i, lastMessage);
          int messageCount = await _findNewMessageCount(user: us);
          res.add(NewMessages(user: us, messageCount: messageCount));
        }
      }
      return res;
    } catch (e) {
      logError(e.toString()); 
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
      
      return await databaseHelper.insertAMessageToDB(message,from);

     

      
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

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

  Future<int> _findNewMessageCount({required User user}) async {
    bool istrue = false;

    var messages = await databaseHelper.fetchAllMessageFromAChat(user.id);
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
}

// ///get message by its id from local DB [messages] table
// ///
// Future<Message> fetchLocalMessage(int id) async {
//   var re = await databaseHelper.db
//       .rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
//   return MessageModel.fromMap(re[0]);
// }

// Future<void> updateDBColumn(
//     {required String tableName,
//     required Map<String, dynamic> object,
//     required int id}) async {
//   await databaseHelper.db
//       .update("recent_chats", object, where: "id = ?", whereArgs: [id]);
// }



// Future<List<dynamic>> _fetchAllMessageFromAChat(int chatId) async {
//   return await databaseHelper.db
//       .rawQuery("SELECT * FROM messages WHERE chat_id = ?", [chatId]);
// }

///query list of users from table [recent_chats] using id or username
///
///if no argument is passed, it will query all user
///
// Future<List<Map<String, dynamic>>> _fetchUsersFromDB(
//     {String? userName, int? id}) async {
//   if (userName != null) {
//     return await databaseHelper.db
//         .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$userName'");
//   }
//   if (id != null) {
//     return await databaseHelper.db
//         .rawQuery("SELECT * FROM recent_chats WHERE id = '$id'");
//   }
//   return await databaseHelper.db.rawQuery("SELECT * FROM recent_chats");
// }

// Future<int> _insertAMessageToDB(Message message) async {
//   return await databaseHelper.db.insert(
//     'messages',
//     MessageModel.fromMessage(message).toMap(),
//   );
// }
