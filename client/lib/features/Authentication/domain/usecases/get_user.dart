// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

class GetUser extends UseCase<User, GetUserParams> {
  final UserRepository repository;
  GetUser({required this.repository});
  @override
  Future<Either<Failure, User>> call(params) async {
    return await repository.getUser(params.username, params.password,params.onNewMessageCachingComplete);
  }
}

class GetUserParams extends Params {
  final String username;
  final String password;final void Function() onNewMessageCachingComplete;
  GetUserParams({
    required this.username,
    required this.password,
    required this.onNewMessageCachingComplete,
  });
}
