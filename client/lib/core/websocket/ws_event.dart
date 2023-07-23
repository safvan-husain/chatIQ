import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WSEvent {
  final String eventName;
  final String senderUsername;
  final String recieverUsername;
  final String message;

  const WSEvent(
    this.eventName,
    this.senderUsername,
    this.recieverUsername,
    this.message,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventName': eventName,
      'senderUsername': senderUsername,
      'recieverUsername': recieverUsername,
      'message': message,
    };
  }

  factory WSEvent.fromMap(Map<String, dynamic> map) {
    return WSEvent(
      map['eventName'] as String,
      map['senderUsername'] as String,
      map['recieverUsername'] as String,
      map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WSEvent.fromJson(String source) =>
      WSEvent.fromMap(json.decode(source) as Map<String, dynamic>);
}
