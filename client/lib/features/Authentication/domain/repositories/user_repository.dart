import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class UserRepository {
  ///calls the http://server.com/getuser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, User>> getUser(
    String emailorUsername,
    String password,
  );

  ///returns a [User] for success [Failure] for any error code
  ///
  Future<Either<Failure, User>> getCachedUser();

  ///post the http://server.com/registerUser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, User>> registerUser(
    String email,
    String username,
    String password,
  );

  ///post the http://server.com/registerUser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, User>> loginUsingGoogle(String email);
}
