// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/features/video_call/data/datasources/video_call_local_data_source.dart';

import '../../domain/repositories/video_call_repository.dart';
import '../datasources/video_call_remote_data_source.dart';

class VideoCallRepositoryImpl extends VideoCallRepository {
  VideoCallLocalDataSource _localDataSource;
  VideoCallRemoteDataSource _remoteDataSource;
  VideoCallRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );
  @override
  Future<Either<Failure, void>> answerCall() {
    // TODO: implement answerCall
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> makeCall() {
    // TODO: implement makeCall
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> rejectCall() {
    // TODO: implement rejectCall
    throw UnimplementedError();
  }
}
