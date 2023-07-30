// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ShowChatEvent extends ChatEvent {
  final String chatId;
  const ShowChatEvent({required this.chatId});
}

class SendMessageEvent extends ChatEvent {
  final Message message;
  final String myid;
  final String to;

  const SendMessageEvent({
    required this.message,
    required this.myid,
    required this.to,
  });
}

class CacheMessageEvent extends ChatEvent {
  final String message;
  final User to;

  const CacheMessageEvent({
    required this.message,
    required this.to,
  });
}

class UpdateLastVisitEvent extends ChatEvent {
  final String userName;
  const UpdateLastVisitEvent({
    required this.userName,
  });
}
