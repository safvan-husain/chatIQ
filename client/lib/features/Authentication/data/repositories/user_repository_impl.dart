import 'dart:developer';

import 'package:client/core/error/exception.dart';
import 'package:client/features/Authentication/data/datasources/user_local_data_source.dart';
import 'package:client/platform/network_info.dart';
import 'package:dartz/dartz.dart';

import 'package:client/features/Authentication/domain/entities/user.dart';

import 'package:client/core/error/failure.dart';

import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUser(
    String emailorUsername,
    String password,
  ) async {
    try {
      User user = await remoteDataSource.getUser(emailorUsername, password);
      localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> registerUser(
    String email,
    String username,
    String password,
  ) async {
    try {
      User user = await remoteDataSource.registerUser(
        email,
        username,
        password,
      );
      localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      return Right(await localDataSource.getUser());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loginUsingGoogle(String email) async {
    try {
      var user = await remoteDataSource.getUserWithGoogle(email);
      localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
