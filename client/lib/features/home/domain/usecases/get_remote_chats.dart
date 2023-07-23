import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import '../repositories/home_repositoy.dart';

class GetRemoteChats {
  final HomeRepository homeRepository;
  GetRemoteChats({required this.homeRepository});
  Future<Either<Failure, List<User>>> call({required String appToken}) async {
    return await homeRepository.getRemoteChats(token: appToken);
  }
}
