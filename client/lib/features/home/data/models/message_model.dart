// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/features/home/domain/entities/message.dart';

class MessageModel extends Message {
  String msgtext, sender;
  bool isme, isread;
  DateTime time;

  MessageModel({
    required this.sender,
    required this.isread,
    required this.time,
    required this.isme,
    required this.msgtext,
  }) : super(
          sender: sender,
          isread: isread,
          time: time,
          isme: isme,
          msgtext: msgtext,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender.toString(),
      'isread': isread,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'] as String,
      isread: map['isread'] as bool,
      time: map['time'] as DateTime,
      isme: map['isme'] as bool,
      msgtext: map['msgtext'] as String,
    );
  }
  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
      sender: message.sender,
      isread: message.isread,
      time: message.time,
      isme: message.isme,
      msgtext: message.msgtext,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
