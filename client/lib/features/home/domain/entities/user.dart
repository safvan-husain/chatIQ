import 'package:equatable/equatable.dart';

import '../../../../common/entity/message.dart';

// ignore: must_be_immutable
class User extends Equatable {
  final String username;
  Message? lastMessage;
  int? lastSeenMessageId;
  final int id;

  User({
    required this.username,
    required this.lastMessage,
    required this.lastSeenMessageId,
    required this.id,
  });
  setLastSeenMessage(int lastSeenMsgId) {
    lastSeenMessageId = lastSeenMsgId;
  }

  setLastMessageId(int lastMsg) {
    lastMessage!.id = lastMsg;
  }

  @override
  List<Object?> get props => [username, lastMessage, id, lastSeenMessageId];
}
