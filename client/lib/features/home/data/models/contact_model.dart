import 'dart:convert';

import '../../domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({required super.username});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
