// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:client/features/home/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/database/data_base_helper.dart';
import '../../domain/entities/message.dart';

abstract class HomeLocalDataSource {
  ///get all account[User] that user chatted with
  ///
  ///throw [CacheException] if no cache data is present
  Future<List<User>> getChats();

  /// remove [User] from cache
  Future<bool> logOut();
  Future<int> cacheMessage(String to, String message);
}

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  @override
  Future<List<User>> getChats() async {
    List<User> users = [];
    DatabaseHelper databaseHelper = Injection.injector.get();
    List<Map> usersMap =
        await databaseHelper.db.rawQuery("SELECT * FROM recent_chats");
    if (usersMap.isEmpty) {
      log('no saved chats');
    } else {
      log(usersMap.length.toString());
      usersMap.forEach((element) {
        User user =
            User(email: element['user_name'], username: element['user_name']);
        user.setId(element['id']);
        users.add(user);
      });
    }

    return users;
  }

  @override
  Future<bool> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString('user', '');
  }

  @override
  Future<int> cacheMessage(String to, String message) async {
    DatabaseHelper databaseHelper = Injection.injector.get();
    var re = await databaseHelper.db
        .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$to'");
    var id = await databaseHelper.db.insert(
      'messages',
      {
        'message_text': message,
        'timestamp': DateTime.now().microsecondsSinceEpoch.toString(),
        'chat_id': re[0]['id']
      },
    );

    return re[0]['id'] as int;
  }
}
