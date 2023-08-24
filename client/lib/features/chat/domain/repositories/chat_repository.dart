import 'package:client/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/entity/message.dart';

abstract class ChatRepository {
  ///gets the list of [Message] from cache
  ///
  ///returns a [Message] for success [Failure] for any error code
  Future<Either<Failure, List<Message>>> showMessages(String chatId);

  ///update last seen message id to the cached user.
  ///
  /// [Failure] for any error code
  Future<Either<Failure, void>> updateLasVisit(String userName);

  ///post a [Message] to the http://server.com/sendMessage
  ///
  ///returns [bool] for success [Failure] for any error code
  Future<Either<Failure, Message>> sendMessage(
    Message message,
    String myid,
    String to,
  );
}
