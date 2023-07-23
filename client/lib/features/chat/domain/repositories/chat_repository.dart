import 'package:client/core/error/failure.dart';
import 'package:client/features/chat/domain/entities/message.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  ///gets the list of [Message] from cache
  ///
  ///returns a [List][Message] for success [Failure] for any error code
  Future<Either<Failure, List<Message>>> showMessages(String chatId);

  ///post a [Message] to the http://server.com/sendMessage
  ///
  ///returns [bool] for success [Failure] for any error code
  Future<Either<Failure, Message>> sendMessage(
      String message, String myid, User to);
}
