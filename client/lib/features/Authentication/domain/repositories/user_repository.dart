import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/entity/message.dart';
import '../entities/user.dart';

abstract class UserRepository {
  ///going to reach out http://server.com/auth/sign-in
  ///
  ///Fear not, for victory brings forth a glorious [User], but beware the cheeky [Failure]
  Future<Either<Failure, User>> getUser(
    String emailorUsername,
    String password,
    void Function() onNewMessageCachingComplete,
  );

  ///for victory brings forth a glorious [User],
  ///
  /// but beware the cheeky [Failure]
  Future<Either<Failure, User>> getCachedUser(
      void Function() onNewMessageCachingComplete);

  ///going to reach out http://server.com/auth/sign-up
  ///
  ///Fear not, for victory brings forth a glorious [User], but beware any [Failure]
  Future<Either<Failure, User>> registerUser(
    String email,
    String username,
    String password,
  );

  ///going to reach out http://server.com/auth/google-in
  ///
  ///Fear not, for victory brings forth a glorious [User], but beware any [Failure]
  Future<Either<Failure, User>> loginUsingGoogle(
    String email,
    
    void Function() onNewMessageCachingComplete,
  );

  ///
  Future<Either<Failure, Map<User, List<Message>>>> getUnredChats(
      String authToken);
}
