import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/video_call/domain/repositories/video_call_repository.dart';

class RejectCall extends UseCase<void, NoParams> {
  final VideoCallRepository _repository;
  RejectCall(
    this._repository,
  );
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.rejectCall();
  }
}
