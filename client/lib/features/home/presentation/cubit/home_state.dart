// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'home_cubit.dart';

///Both [User] and unread [messageCount]
class NewMessages {
  User user;
  late int messageCount;
  NewMessages({
    required this.user,
    required this.messageCount,
  });
}

abstract class HomeState extends Equatable {
  final List<Contact>? contacts;
  List<NewMessages> newMessages;
  final DateTime time = DateTime.now();

  HomeState({
    this.contacts,
    this.newMessages = const [],
  });

  @override
  List<Object> get props => [time];
}

class HomeStateImpl extends HomeState {
  HomeStateImpl({
    super.newMessages = const [],
  });
}

class ContactStateImpl extends HomeState {
  ContactStateImpl({required super.contacts, super.newMessages});
}

class NewMessageState extends HomeState {
  NewMessageState({
    required super.newMessages,
  });
}

class HomeLogOut extends HomeState {
  HomeLogOut({
    super.contacts = const [],
  });
}
