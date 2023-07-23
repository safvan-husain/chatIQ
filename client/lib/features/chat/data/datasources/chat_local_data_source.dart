import 'package:client/features/chat/data/models/message_model.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/database/data_base_helper.dart';
import '../../../home/data/models/user_model.dart';
import '../../domain/entities/message.dart';

class ChatLocalDataSource {
  ///cache the [User] if not alredy cached
  Future<void> cacheFriend(User user) async {
    DatabaseHelper databaseHelper = Injection.injector.get();
    Map<String, dynamic> userMap = UserModel.fromUser(user).toMap();
    var re = await databaseHelper.db.rawQuery(
        "SELECT * FROM recent_chats WHERE user_name = '${user.username}'");
    if (re.isEmpty) {
      await databaseHelper.db
          .insert('recent_chats', {'user_name': user.username});
    }
  }

  Future<Message> cacheMessage(String to, String message) async {
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
    return Message(
        chatId: re[0]['id'] as int, content: message, time: DateTime.now());
  }

  Future<List<Message>> showCachedMessages(String to) async {
    DatabaseHelper databaseHelper = Injection.injector.get();
    var re = await databaseHelper.db
        .rawQuery("SELECT * FROM recent_chats WHERE user_name = '$to'");
    if (re.isNotEmpty) {
      var messages = await databaseHelper.db
          .rawQuery("SELECT * FROM messages WHERE chat_id = '${re[0]['id']}'");
      print(messages);
      return messages.map((i) => MessageModel.fromMap(i)).toList();
    }
    return [];
  }
}
