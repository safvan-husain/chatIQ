// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  final List<User> contacts;
  final List<User> chats;
  const HomeState({
    required this.chats,
    required this.contacts,
  });

  @override
  List<Object> get props => [chats, contacts];
}

class HomeStateImpl extends HomeState {
  const HomeStateImpl({
    required super.chats,
    super.contacts = const [],
  });
}

class ContactStateImpl extends HomeState {
  const ContactStateImpl({
    required super.chats,
    required super.contacts,
  });
}

class HomeLogOut extends HomeState {
  const HomeLogOut({
    super.chats = const [],
    super.contacts = const [],
  });
}
