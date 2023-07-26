// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'home_cubit.dart';

//refactornot try to use object key-value insted of this classs
class NewMessages {
  final int chatId;
  late int messageCount;
  NewMessages({
    required this.chatId,
    required this.messageCount,
  });
  factory NewMessages.fromMap(Map<String, dynamic> map) {
    return NewMessages(
      chatId: map['chatId'] as int,
      messageCount: map['messageCount'] as int,
    );
  }
}

abstract class HomeState extends Equatable {
  final List<User>? contacts;
  final List<User> chats;
  List<NewMessages> newMessages;
  final DateTime time = DateTime.now();

  HomeState({
    required this.chats,
    this.contacts,
    this.newMessages = const [],
  });

  @override
  List<Object> get props => [time];
}

class HomeStateImpl extends HomeState {
  HomeStateImpl({
    required super.chats,
    super.newMessages = const [],
  });
}

class ContactStateImpl extends HomeState {
  ContactStateImpl({
    required super.chats,
    required super.contacts,
  });
}

class NewMessageState extends HomeState {
  NewMessageState({
    required super.chats,
    required super.newMessages,
  });
}

class HomeLogOut extends HomeState {
  HomeLogOut({
    super.chats = const [],
    super.contacts = const [],
  });
}
