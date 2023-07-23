class Message {
  String msgtext, sender;
  bool isme, isread;
  DateTime time;
  Message({
    required this.sender,
    required this.isread,
    required this.time,
    required this.isme,
    required this.msgtext,
  });
}
