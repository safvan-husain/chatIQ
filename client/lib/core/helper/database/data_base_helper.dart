import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../common/entity/message.dart';
import '../../../common/model/message_model.dart';
import 'package:client/features/home/data/models/user_model.dart';

import '../../../features/home/domain/entities/user.dart';
import '../../../features/home/presentation/cubit/home_cubit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static late Database _db;

  DatabaseHelper.internal();
  //table names
  static const String recentChats = "recent_chats";
  static const String messeages = 'messages';

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "chats.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Database get db {
    return _db;
  }

  Future<void> deleteAllData() async {
    await _db.delete(recentChats);
    await _db.delete(messeages);
  }

  Future<Message> getMessageWithId(int id) async {
    var re = await _db.rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
    return MessageModel.fromMap(re[0]);
  }

  ///update row [id] in [tableName] with [object].
  Future<void> updateDBColumn(
      {required String tableName,
      required Map<String, dynamic> object,
      required int id}) async {
    await _db.update(tableName, object, where: "id = ?", whereArgs: [id]);
  }

  ///if no user cached with [chatterId], it will cache,
  ///
  ///then cache message, also update last message id to the cahed user.
  Future<NewMessages> insertAMessageToDB(
    Message message,
    String chatterId,
  ) async {
    var userMap = await getOrInsertUserFromDB(userName: chatterId);
    UserModel user = UserModel.fromMap(userMap, message);
    //setting chatId to the message before caching.
    message.setChatId(user.id);
    int id = await _insertMessage(message);
    //update last message id to the user cache.
    user.setLastMessageId(id);
    updateDBColumn(
      tableName: recentChats,
      object: user.toMap(),
      id: user.id,
    );
    int newMessagesCount = await _findNewMessageCount(user: user);
    return NewMessages(user: user, messageCount: newMessagesCount);
  }

  Future<Message?> fetchLastMessageFromAChat(int chatId) async {
    var result = await _db.rawQuery(
        "SELECT * FROM messages WHERE chat_id = ? ORDER BY time DESC LIMIT 1",
        [chatId]);
    if (result.isNotEmpty) {
      return MessageModel.fromMap(result[0]);
    } else {
      return null;
    }
  }

  Future<List<dynamic>> fetchAllMessageFromAChat(int chatId) async {
    return await _db
        .rawQuery("SELECT * FROM messages WHERE chat_id = ?", [chatId]);
  }

  ///query user from table [recent_chats] using id or username
  ///
  ///if no row exsist with the username, it will create a new.
  Future<Map<String, dynamic>> getOrInsertUserFromDB({
    String? userName,
    int? id,
  }) async {
    if (userName != null) {
      var re = await _getFriendWithUserName(userName);
      if (re == null) {
        //if username not already cached
        int iD = await _insertFriendToDB(userName);
        return await _getFriendWithId(iD);
      }
      return re;
    }
    throw ('provide userName or Id to getOrInsertUserFromDB');
  }

  Future<int> _insertMessage(Message message) async {
    int id = await db.insert(
      'messages',
      MessageModel.fromMessage(message).toMap(),
    );
    return id;
  }

  Future<int> _findNewMessageCount({required User user}) async {
    bool istrue = false;
//finding new message count by comparing with last seen message id.
    var messages = await fetchAllMessageFromAChat(user.id);
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

  Future<int> _insertFriendToDB(String username) async {
    return await db.insert(
      'recent_chats',
      {'user_name': username},
    );
  }

  ///Return Objects from [recent_chats] Db column.
  Future<List<Map<String, Object?>>> getAllFriends() async {
    return await _db.rawQuery("SELECT * FROM recent_chats");
  }

  Future<Map<String, Object?>> _getFriendWithId(int iD) async {
    var re = await _db.rawQuery("SELECT * FROM recent_chats WHERE id = '$iD'");
    return re.first;
  }

  Future<Map<String, Object?>?> _getFriendWithUserName(String userName) async {
    var re = await _db
        .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$userName'");
    if (re.isEmpty) {
      return null;
    }
    return re[0];
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE recent_chats (id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' user_name TEXT,'
        ' dp TEXT,'
        ' last_message INTEGER,'
        ' last_seen_message INTEGER,'
        'FOREIGN KEY (last_message) REFERENCES messages(id),'
        'FOREIGN KEY (last_seen_message) REFERENCES messages(id)'
        ')');
    await db
        .execute('CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' chat_id INTEGER,'
            ' time INTEGER,'
            ' message TEXT,'
            ' isme INTEGER,'
            ' FOREIGN KEY (chat_id) REFERENCES recent_chats(id)'
            ')');
  }
}
