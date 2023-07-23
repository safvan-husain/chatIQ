// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:client/core/error/exception.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/features/home/data/datasources/home_local_data_source.dart';
import 'package:client/features/home/data/datasources/home_remote_data_source.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/platform/network_info.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/home_repositoy.dart';

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
  Future<Either<Failure, List<User>>> getRemoteChats(
      {required String token}) async {
    List<User> users = [];
    if (await networkInfo.isConnected) {
      try {
        users.addAll(await remoteDataSource.getUnreadChats(token: token));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
    log(users.length.toString());
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
  Future<Either<Failure, List<User>>> getLocalChats() async {
    try {
      return Right(await localDataSource.getChats());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> cacheMessage(String message, String from) async {
    try {
      return Right(await localDataSource.cacheMessage(from, message));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
