import 'dart:developer';

import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';

abstract class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource({required this.sharedPreferences});

  ///Get the cached [User] d
  ///
  ///throw [CacheException] if no cache data is present
  Future<User> getUser();
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
    log(userJson);
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
