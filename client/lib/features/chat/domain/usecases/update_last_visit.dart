// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';

class UpdateLastVisit extends UseCase<void, String> {
  final ChatRepository chatRepository;
  UpdateLastVisit({
    required this.chatRepository,
  });
  @override
  Future<Either<Failure, void>> call(String userName) {
    return chatRepository.updateLasVisit(userName);
  }
}
