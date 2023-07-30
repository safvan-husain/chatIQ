// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../common/entity/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage extends UseCase<Message, SendMessageParams> {
  final ChatRepository repository;
  SendMessage({
    required this.repository,
  });

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.message,
      params.myid,
      params.to,
    );
  }
}

class SendMessageParams extends Params {
  final Message message;
  final String myid;
  final String to;

  SendMessageParams(this.message, this.myid, this.to);
}
