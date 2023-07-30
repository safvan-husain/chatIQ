import 'package:client/core/usecases/use_case.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../presentation/cubit/home_cubit.dart';
import '../repositories/home_repositoy.dart';

class GetLocalChats extends UseCase<List<NewMessages>, NoParams> {
  final HomeRepository _homeRepository;
  GetLocalChats(this._homeRepository);
  Future<Either<Failure, List<NewMessages>>> call(NoParams) async {
    return await _homeRepository.getLocalChats();
  }
}
