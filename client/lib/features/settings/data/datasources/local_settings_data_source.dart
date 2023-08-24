import 'package:client/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/helper/database/data_base_helper.dart';

class LocalSettingDataSource {
  final DatabaseHelper _databaseHelper;

  LocalSettingDataSource(this._databaseHelper);

  Future<void> deleteChats() async {
    try {
      await _databaseHelper.deleteAllData();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<bool> logOut() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return await sharedPreferences.setString('user', '');
    } catch (e) {
      throw CacheException();
    }
  }
}
