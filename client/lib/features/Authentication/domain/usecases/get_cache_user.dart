import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

class GetCachedUser extends UseCase<User, GetCachedUserParams> {
  final UserRepository repository;
  GetCachedUser({required this.repository});
  @override
  Future<Either<Failure, User>> call(params) async {
    return await repository.getCachedUser(params.onNewMessageCachingComplete);
  }
}

class GetCachedUserParams extends Params {
  final void Function() onNewMessageCachingComplete;

  GetCachedUserParams(this.onNewMessageCachingComplete);
}
