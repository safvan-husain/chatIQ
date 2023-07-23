import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class Logout {
  final HomeRepository _homeRepository;
  Logout(this._homeRepository);
  Future<Either<Failure, bool>> call() async {
    return await _homeRepository.logOut();
  }
}
