import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/message.dart';
import '../entities/user.dart';

abstract class HomeRepository {
  ///calls the http://server.com/getuser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, bool>> logOut();

  ///post the http://server.com/registerUser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, List<User>>> getRemoteChats({required String token});

  ///post the http://server.com/registerUser?email=email endpoint
  ///
  ///returns a [User] for success [Failure] for any error code
  Future<Either<Failure, List<User>>> getLocalChats();
  Future<Either<Failure, int>> cacheMessage(String message, String from);
}
