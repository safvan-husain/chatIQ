import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static late Database _db;

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "chats.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Database get db {
    return _db;
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
