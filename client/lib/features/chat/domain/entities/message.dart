// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  final int chatId;
  final String content;
  final DateTime time;

  Message({
    required this.chatId,
    required this.content,
    required this.time,
  });
}
