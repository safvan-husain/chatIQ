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
      List<dynamic> usersMapList = await databaseHelper.getAllFriends();
      if (usersMapList.isNotEmpty) {
        //for showing user tiles in the home screen,
        for (var userMap in usersMapList) {
          int? lastMessageId = userMap['last_message'];
          Message? lastMessage;
          //if there is last message id assigned to the user object in the database.
          lastMessage = lastMessageId != null
              ? await databaseHelper.getMessageWithId(lastMessageId)
              : null;
          User user = UserModel.fromMap(userMap, lastMessage);
          //finding new messages to show the label.
          int messageCount = await _findNewMessageCount(user: user);
          res.add(NewMessages(user: user, messageCount: messageCount));
        }
      }
      return res;
    } catch (e) {
      logError("${e}here");
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
      return await databaseHelper.insertAMessageToDB(message, from);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheFriend(String username) async {
    try {
      await databaseHelper.getOrInsertUserFromDB(userName: username);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<int> _findNewMessageCount({required User user}) async {
    bool istrue = false;

    var messages = await databaseHelper.fetchAllMessageFromAChat(user.id);
    if (messages.isEmpty) {
      return 0;
    }
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
