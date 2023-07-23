import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/home_repositoy.dart';

class GetLocalChats {
  final HomeRepository _homeRepository;
  GetLocalChats(this._homeRepository);
  Future<Either<Failure, List<User>>> call() async {
    return await _homeRepository.getLocalChats();
  }
}
