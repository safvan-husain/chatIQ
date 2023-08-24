import 'dart:developer';

import 'package:client/common/entity/message.dart';
import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/helper/database/data_base_helper.dart';
import '../models/remote_message_model.dart';

abstract class UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  DatabaseHelper dataBaseHelper = Injection.injector.get();
  UserLocalDataSource({required this.sharedPreferences});

  ///Who's there? It's the sneaky [User] hiding in the cache, waiting to be found!
  ///
  ///But watch out! If the cache is empty, be ready to catch the thrown [CacheException]!
  Future<User> getUser();

  ///wanna cache the [User]?
  ///
  ///but be careful, I will throw [CacheException] if couldn't do it.
  Future<void> cacheUser(User user);

  ///[CacheException] for any error.
  Future<void> cacheAllNewMessages(List<RemoteMesseageModel> messeges);
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  UserLocalDataSourceImpl({required super.sharedPreferences});

  @override
  Future<User> getUser() async {
    final String? userJson = sharedPreferences.getString('user');
    if (userJson == null || userJson == "") {
      throw CacheException();
    }
    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> cacheUser(User user) async {
    log(UserModel.fromUser(user).toJson());
    sharedPreferences
        .setString('user', UserModel.fromUser(user).toJson())
        .onError((e, stack) {
      throw CacheException();
    });
  }

  @override
  Future<void> cacheAllNewMessages(messeges) async {
    for (var message in messeges) {
      late int chatId;

      var users =
          await dataBaseHelper.getOrInsertUserFromDB(userName: message.sender);
      chatId = users['id'];
      await dataBaseHelper.insertAMessageToDB(
        Message(
          chatId: chatId,
          time: message.dateTime,
          isme: false,
          content: message.content,
        ),
        message.sender,
      );
    }
  }
}
