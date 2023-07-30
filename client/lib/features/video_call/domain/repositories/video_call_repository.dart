import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class VideoCallRepository {
  Future<Either<Failure, void>> makeCall();
  Future<Either<Failure, void>> answerCall();
  Future<Either<Failure, void>> rejectCall();
}
