// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:client/core/error/exception.dart';
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart';

import '../../../../common/entity/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, Message>> sendMessage(message, myid, to) async {
    try {
      await localDataSource.cacheFriend(to);

      await remoteDataSource.sendMessage(message, myid, to);
      return Right(
        await localDataSource.cacheMessage(
          message,
          to,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> showMessages(String chatId) async {
    try {
      return Right(await localDataSource.showCachedMessages(chatId));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateLasVisit(String userName) async {
    try {
      return Right(await localDataSource.updateLastVisit(userName));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
