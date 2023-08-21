import 'package:client/core/error/exception.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/features/home/data/datasources/home_local_data_source.dart';
import 'package:client/features/home/data/datasources/home_remote_data_source.dart';
import 'package:client/platform/network_info.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/entity/message.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/home_repositoy.dart';
import '../../presentation/cubit/home_cubit.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeLocalDataSource localDataSource;
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  HomeRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, List<Contact>>> getAllPeople(
      {required String token}) async {
    List<Contact> users = [];
    if (await networkInfo.isConnected) {
      try {
        users.addAll(await remoteDataSource.getAllPeople(token: token));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
    return Right(users);
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      return Right(await localDataSource.logOut());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<NewMessages>>> getLocalChats() async {
    try {
      return Right(await localDataSource.getChats());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NewMessages>> cacheMessage(
      Message message, String from) async {
    try {
      await localDataSource.cacheFriend(from);
      return Right(await localDataSource.cacheMessage(message, from));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
