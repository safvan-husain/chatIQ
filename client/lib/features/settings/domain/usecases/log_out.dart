import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/settings_repository.dart';

class Logout extends UseCase<bool, NoParams> {
  final SettingsRepository _homeRepository;
  Logout(this._homeRepository);
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await _homeRepository.logOut();
  }
}
