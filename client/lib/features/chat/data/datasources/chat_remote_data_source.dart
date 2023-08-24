import 'package:client/common/entity/message.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/helper/websocket/ws_event.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource();

  ///will send message to [to] through websocket.
  Future<bool> sendMessage(
    Message message,
    String myid,
    String to,
  ) async {
    WebSocketHelper webSocketHelper = Injection.injector.get();
    webSocketHelper.channel.sink.add(WSEvent(
      'message',
      myid,
      to,
      message.content,
      message.time,
    ).toJson());
    return true;
  }
}
