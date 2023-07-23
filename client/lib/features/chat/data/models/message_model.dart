import 'dart:convert';

import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.chatId,
    required super.content,
    required super.time,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'message_text': content,
      'timestamp': time.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        chatId: map['chat_id'] as int,
        content: map['message_text'] as String,
        time: DateTime.now()
        // time: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
        );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
