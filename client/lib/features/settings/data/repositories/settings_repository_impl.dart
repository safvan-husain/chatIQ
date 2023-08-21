import 'package:client/core/error/exception.dart';
import 'package:client/core/error/failure.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_settings_data_source.dart';
import '../datasources/remote_settings_data_source.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final RemoteSettingDataSource remoteSource;
  final LocalSettingDataSource localSource;

  SettingsRepositoryImpl(this.remoteSource, this.localSource);
  @override
  Future<Either<Failure, void>> deleteLocalChats() async {
    try {
      return Right(await localSource.deleteChats());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRemoteData(String authToken) async {
    try {
      if (await remoteSource.deleteData(authToken)) {
        return Right(await localSource.deleteChats());
      }
      return Left(ServerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      return Right(await localSource.logOut());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
