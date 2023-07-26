import 'package:client/core/error/failure.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/entity/message.dart';

abstract class ChatRepository {
  ///gets the list of [Message] from cache
  ///
  ///returns a [List][Message] for success [Failure] for any error code
  Future<Either<Failure, List<Message>>> showMessages(String chatId);

  ///
  ///returns a [List][Message] for success [Failure] for any error code
  Future<Either<Failure, void>> updateLasVisit(User user);

  ///post a [Message] to the http://server.com/sendMessage
  ///
  ///returns [bool] for success [Failure] for any error code
  Future<Either<Failure, Message>> sendMessage(
    Message message,
    String myid,
    User to,
  );
}
