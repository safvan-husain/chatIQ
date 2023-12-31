import 'dart:convert';

import 'package:client/common/entity/message.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WSEvent {
  final String eventName;
  final String senderUsername;
  final String recieverUsername;
  final String? data;
  final DateTime time;

  const WSEvent(
    this.eventName,
    this.senderUsername,
    this.recieverUsername,
    this.data,
    this.time,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventName': eventName,
      'senderUsername': senderUsername,
      'recieverUsername': recieverUsername,
      'data': data,
      'time': time.millisecondsSinceEpoch,
    };
  }

  Message toMessage() {
    return Message(
      chatId: null,
      content: data!,
      isme: false,
      time: time,
    );
  }

  factory WSEvent.fromMap(Map<String, dynamic> map) {
    return WSEvent(
      map['eventName'] as String,
      map['senderUsername'] as String,
      map['recieverUsername'] as String,
      map['data'] as String?,
      DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WSEvent.fromJson(String source) =>
      WSEvent.fromMap(json.decode(source) as Map<String, dynamic>);
}
