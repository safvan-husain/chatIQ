// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:client/core/error/exception.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:client/features/chat/domain/entities/message.dart';

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
      return Right(await localDataSource.cacheMessage(to.username, message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> showMessages(String chatId) async {
    var r = await localDataSource.showCachedMessages(chatId);
    return Right(r);
  }
}
