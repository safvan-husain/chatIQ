// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';

class LoginWithGoogle extends UseCase<User, LoginWithGoogleParams> {
  final UserRepository userRepository;
  LoginWithGoogle({
    required this.userRepository,
  });
  @override
  Future<Either<Failure, User>> call(params) async {
    return await userRepository.loginUsingGoogle(params.email);
  }
}

class LoginWithGoogleParams extends Params {
  final String email;
  LoginWithGoogleParams({
    required this.email,
  });
}
