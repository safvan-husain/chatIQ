// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/home/domain/entities/message.dart';

class CacheMessage extends UseCase<int, CacheMessageParams> {
  final HomeRepository repository;

  CacheMessage(this.repository);
  @override
  Future<Either<Failure, int>> call(CacheMessageParams params) async {
    return await repository.cacheMessage(params.message, params.from);
  }
}

class CacheMessageParams extends Params {
  final String message;
  final String from;

  CacheMessageParams({
    required this.message,
    required this.from,
  });
}
