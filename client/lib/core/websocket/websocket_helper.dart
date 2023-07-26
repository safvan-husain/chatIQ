import 'dart:convert';
import 'dart:developer';

import 'package:client/core/websocket/ws_event.dart';
import 'package:web_socket_channel/io.dart';

import '../../common/entity/message.dart';
import '../../constance/constant_variebles.dart';

class WebSocketHelper {
  static final WebSocketHelper _instance = WebSocketHelper.internal();
  WebSocketHelper.internal();
  factory WebSocketHelper() => _instance;
  late IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;
  initSocket(myid, void Function(Message, String) onMessage) {
    try {
      log('connecting websocket with $myid');
      _channel = IOWebSocketChannel.connect("ws://$ipAddress:3000/$myid");
      _channel.stream.listen(
        (message) async {
          if (json.decode(message)['cmd'] != null) {
            log(message);
          } else {
            WSEvent event = WSEvent.fromJson(message);
            if (event.eventName == 'message') {
              onMessage(event.toMessage(), event.senderUsername);
            }
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          log("Web socket is closed");
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (e) {
      throw Error();
    }
  }
}
