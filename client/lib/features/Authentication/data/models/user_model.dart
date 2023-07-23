// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/features/Authentication/domain/entities/user.dart';

class UserModel extends User {
  // final String name;
  // final String email;
  // final String password;

  const UserModel({
    required super.username,
    required super.email,
    required super.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
    );
  }
  factory UserModel.fromApiJson(String jsonUser) {
    Map<String, dynamic> userMap = json.decode(jsonUser);
    return UserModel(
      username: userMap['user']['username'] as String,
      email: userMap['user']['email'] as String,
      token: userMap['token'] as String,
    );
  }
  factory UserModel.fromUser(User user) {
    return UserModel(
      username: user.username,
      email: user.email,
      token: user.token,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
