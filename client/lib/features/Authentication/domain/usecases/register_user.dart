import 'package:client/core/usecases/use_case.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUser extends UseCase<User, RegisterUserParams> {
  final UserRepository authenticationRepository;
  RegisterUser({required this.authenticationRepository});

  ///used to register the user
  @override
  Future<Either<Failure, User>> call(params) async {
    return authenticationRepository.registerUser(
      params.email,
      params.username,
      params.password,
    );
  }
}

class RegisterUserParams extends Params {
  final String email;
  final String username;
  final String password;
  RegisterUserParams({
    required this.email,
    required this.username,
    required this.password,
  });
}
