import 'dart:io' as io;
import 'package:dartz/dartz.dart';
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
  String recentChats = "recent_chats";
  String messeages = 'messages';

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "chats.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Database get db {
    return _db;
  }

  Future<void> clearAllData() async {
    await _db.delete(recentChats);
    await _db.delete(messeages);
  }

  ///returns true if a user exist with this username
  ///
  Future<bool> isUserCached(String username) async {
    var re = await fetchUsersFromDB(userName: username);
    if (re.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  ///get message by its id from local DB [messages] table
  ///
  Future<Message> fetchLocalMessage(int id) async {
    var re = await _db.rawQuery("SELECT * FROM messages WHERE id = ?", [id]);
    return MessageModel.fromMap(re[0]);
  }

  Future<void> updateDBColumn(
      {required String tableName,
      required Map<String, dynamic> object,
      required int id}) async {
    await _db.update("recent_chats", object, where: "id = ?", whereArgs: [id]);
  }

  Future<NewMessages> insertAMessageToDB(Message message, String chatter) async {
    int id = await db.insert(
      'messages',
      MessageModel.fromMessage(message).toMap(),
    );
    var userMap = await fetchUsersFromDB(userName: chatter);
    UserModel user = UserModel.fromMap(userMap[0], message);
    message.setChatId(user.id);
    user.setLastMessageId(id);
    updateDBColumn(
      tableName: 'recent_chats',
      object: user.toMap(),
      id: user.id,
    );
    int newMessagesCount = await _findNewMessageCount(user: user);
    return NewMessages(user: user, messageCount: newMessagesCount);
  }

  Future<int> _findNewMessageCount({required User user}) async {
    bool istrue = false;

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

//create a row in [recent_chats] with this username
  Future<int> insertAuserToDB(String username) async {
    return await db.insert(
      'recent_chats',
      {'user_name': username},
    );
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

  ///query list of users from table [recent_chats] using id or username
  ///
  ///if no argument is passed, it will query all user
  ///
  Future<List<Map<String, dynamic>>> fetchUsersFromDB(
      {String? userName, int? id}) async {
    if (userName != null) {
      return await _db
          .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$userName'");
    }
    if (id != null) {
      return await _db.rawQuery("SELECT * FROM recent_chats WHERE id = '$id'");
    }
    return await _db.rawQuery("SELECT * FROM recent_chats");
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
