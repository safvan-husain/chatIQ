// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:http/http.dart' as http;

import 'package:client/common/entity/message.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/Injector/ws_injector.dart';
import '../../../../core/helper/websocket/ws_event.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource();
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
