import 'dart:convert';

import '../../domain/entities/remote_message.dart';

class RemoteMesseageModel extends RemoteMesseage {
  RemoteMesseageModel(
    super.sender,
    super.reciever,
    super.content,
    super.dateTime,
  );
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'sender': sender,
  //     'reciever': reciever,
  //     'content': content,
  //     'dateTime': dateTime.millisecondsSinceEpoch,
  //   };
  // }

  factory RemoteMesseageModel.fromMap(Map<String, dynamic> map) {
    return RemoteMesseageModel(
      map['senderId'] as String,
      map['receiverId'] as String,
      map['msgText'] as String,
      DateTime.parse(map['createdAt']),
    );
  }

  // String toJson() => json.encode(toMap());

  factory RemoteMesseageModel.fromJson(String source) =>
      RemoteMesseageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
