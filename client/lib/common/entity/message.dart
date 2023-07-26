class Message {
  int? chatId;
  int? id;
  final String content;
  bool isme;
  DateTime time;
  Message({
    this.id,
    required this.chatId,
    required this.time,
    required this.isme,
    required this.content,
  });
  setChatId(int id) {
    chatId = id;
  }
}
