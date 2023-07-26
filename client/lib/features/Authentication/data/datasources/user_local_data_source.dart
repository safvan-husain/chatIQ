import 'dart:developer';

import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';

abstract class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource({required this.sharedPreferences});

  ///Who's there? It's the sneaky [User] hiding in the cache, waiting to be found!
  ///
  ///But watch out! If the cache is empty, be ready to catch the thrown [CacheException]!
  Future<User> getUser();

  ///wanna cache the [User]? use me
  ///
  ///but be careful, I will throw [CacheException] if couldn't do it.
  Future<void> cacheUser(User user);
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
}
