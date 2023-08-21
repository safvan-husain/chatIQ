import 'package:client/core/error/failure.dart';
import 'package:client/features/settings/domain/repositories/settings_repository.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/usecases/use_case.dart';

class DeleteLocalChats extends UseCase<void, NoParams> {
  final SettingsRepository settingsRepository;

  DeleteLocalChats(this.settingsRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return settingsRepository.deleteLocalChats();
  }
}
