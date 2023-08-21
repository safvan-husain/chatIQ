// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ShowChatEvent extends ChatEvent {
  final String chatId;
  String Function()? setUsername;
  ShowChatEvent({required this.chatId, this.setUsername});
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



class UpdateLastVisitEvent extends ChatEvent {
  final String userName;
  final void Function() onUpdateLastVisitCompleted;
  const UpdateLastVisitEvent({
    required this.userName,
    required this.onUpdateLastVisitCompleted,
  });
}
