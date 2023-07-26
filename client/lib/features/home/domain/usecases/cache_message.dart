// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/common/entity/message.dart';

import '../../presentation/cubit/home_cubit.dart';

class CacheMessage extends UseCase<NewMessages, CacheMessageParams> {
  final HomeRepository repository;

  CacheMessage(this.repository);
  @override
  Future<Either<Failure, NewMessages>> call(
    CacheMessageParams params,
  ) async {
    return await repository.cacheMessage(params.message, params.from);
  }
}

class CacheMessageParams extends Params {
  final Message message;
  final String from;

  CacheMessageParams({
    required this.message,
    required this.from,
  });
}
