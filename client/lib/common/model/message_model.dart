// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/common/entity/message.dart';

class MessageModel extends Message {
  MessageModel({
    super.id,
    required super.chatId,
    required super.time,
    required super.isme,
    required super.content,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'time': time.millisecondsSinceEpoch,
      'message': content,
      'isme': isme == true ? 1 : 0,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      chatId: map['chat_id'] as int,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      content: map['message'] as String,
      isme: map['isme'] == 0 ? false : true,
    );
  }
  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
      id: message.id,
      content: message.content,
      time: message.time,
      isme: message.isme,
      chatId: message.chatId,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
