// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/features/home/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.username,
    required super.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': username,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }
  factory UserModel.fromUser(User user) {
    return UserModel(
      username: user.username,
      email: user.email,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
