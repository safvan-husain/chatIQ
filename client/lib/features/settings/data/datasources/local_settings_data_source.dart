import 'package:client/core/error/exception.dart';

import '../../../../common/entity/message.dart';
import '../../../../core/helper/database/data_base_helper.dart';

class LocalSettingDataSource {
  final DatabaseHelper _databaseHelper;

  LocalSettingDataSource(this._databaseHelper);
  
  Future<void> deleteChats() async {
    try {
      await _databaseHelper.clearAllData();
    } catch (e) {
      throw CacheException();
    }
  }

  // Future<void> cacheChats(List<Message> messages) async {
  //   try {
  //     for (Message message in messages) {
  //       await _databaseHelper.insertAMessageToDB(message);
  //     }
  //   } catch (e) {
  //     throw CacheException();
  //   }
  // }

  Future<bool> logOut() async {
    try {
      return true;
    } catch (e) {
      throw CacheException();
    }
  }
}
