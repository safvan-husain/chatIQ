import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class SettingsRepository {
  ///will remove [User] from cache

  ///for victory [bool], but beware of the cheeky [Failure]
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, void>> deleteLocalChats();
  Future<Either<Failure, void>> deleteRemoteData(String authToken);
}
