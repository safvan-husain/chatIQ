import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/contact.dart';
import '../repositories/home_repositoy.dart';

class GetRemoteChats {
  final HomeRepository homeRepository;
  GetRemoteChats({required this.homeRepository});
  Future<Either<Failure, List<Contact>>> call(
      {required String appToken}) async {
    return await homeRepository.getAllPeople(token: appToken);
  }
}
