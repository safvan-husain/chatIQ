import 'package:client/core/error/failure.dart';
import 'package:client/features/settings/domain/repositories/settings_repository.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/usecases/use_case.dart';

class DeleteRemoteData extends UseCase<void, DeleteRemoteDataParams> {
  final SettingsRepository settingsRepository;

  DeleteRemoteData(this.settingsRepository);
  @override
  Future<Either<Failure, void>> call(DeleteRemoteDataParams params) {
    return settingsRepository.deleteRemoteData(params.authToken);
  }
}
class DeleteRemoteDataParams extends Params {final String authToken;

  DeleteRemoteDataParams(this.authToken);}