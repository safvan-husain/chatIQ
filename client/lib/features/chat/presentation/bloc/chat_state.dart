part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;
  const ChatState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatStateImpl extends ChatState {
  const ChatStateImpl({required super.messages});
}

class ChatFailure extends ChatState {
  final String failureMessages = 'failed some how';
  const ChatFailure({super.messages = const []});
}
