import 'package:client/common/entity/message.dart';
import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../presentation/cubit/home_cubit.dart';
import '../entities/user.dart';

abstract class HomeRepository {
  ///will remove [User] from cache
  ///
  ///for victory  [bool], but beware of the cheeky [Failure]
  Future<Either<Failure, bool>> logOut();

  ///Reaching out http://server.com/
  ///
  ///for victory  list of [User], but beware of the cheeky [Failure]
  Future<Either<Failure, List<User>>> getAllPeople({required String token});

  ///list of [User] wating to be found in the cache who user chatted with
  ///
  ///for victory  list of [User], but beware of the cheeky [Failure]
  Future<Either<Failure, List<User>>> getLocalChats();

  ///wanna cache a message to the storage? perfect!
  ///
  ///for victory [bool], but beware of the cheeky [Failure]
  Future<Either<Failure, NewMessages>> cacheMessage(
      Message message, String from);
}
