import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String email;
  int? _id;

  User({
    required this.username,
    required this.email,
  });
  int? get id => _id;

  void setId(int id) {
    _id = id;
  }

  @override
  List<Object?> get props => [username, email];
}
