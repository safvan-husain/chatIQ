// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/chat/domain/repositories/chat_repository.dart';

import '../../../../common/entity/message.dart';

class ShowMessage extends UseCase<List<Message>, ShowMessageParams> {
  final ChatRepository repository;
  ShowMessage({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<Message>>> call(ShowMessageParams params) {
    return repository.showMessages(params.chatId);
  }
}

class ShowMessageParams extends Params {
  final String chatId;

  ShowMessageParams(this.chatId);
}
