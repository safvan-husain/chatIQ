// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/common/entity/message.dart';
import 'package:client/features/home/domain/entities/user.dart';

// ignore: must_be_immutable
class UserModel extends User {
  UserModel({
    required super.username,
    required super.lastMessage,
    required super.lastSeenMessageId,
    required super.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_name': username,
      'last_message': lastMessage!.id,
      'last_seen_message': lastSeenMessageId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, Message lastMessage) {
    return UserModel(
      username: map['user_name'] as String,
      lastMessage: lastMessage,
      lastSeenMessageId: map['last_seen_message'] as int?,
      id: map['id'] as int,
    );
  }
  factory UserModel.fromApiMap(Map<String, dynamic> map) {
    // Map<String, dynamic> map = json.decode(jsonObject);
    return UserModel(
      username: map['username'] as String,
      lastMessage: null,
      lastSeenMessageId: null,
      id: map['id'] as int,
    );
  }
  factory UserModel.fromUser(User user) {
    return UserModel(
      username: user.username,
      lastMessage: user.lastMessage,
      lastSeenMessageId: user.lastSeenMessageId,
      id: user.id,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source, Message me) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>, me);
}
