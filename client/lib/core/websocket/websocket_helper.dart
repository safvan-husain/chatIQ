import 'dart:convert';
import 'dart:developer';

import 'package:client/core/websocket/ws_event.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

import '../../constance/constant_variebles.dart';

class WebSocketHelper {
  static final WebSocketHelper _instance = WebSocketHelper.internal();
  WebSocketHelper.internal();
  factory WebSocketHelper() => _instance;
  late IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;
  initSocket(myid, void Function(String, String) onMessage) {
    try {
      log('connecting websocket with $myid');
      _channel = IOWebSocketChannel.connect("ws://$ipAddress:3000/$myid");
      _channel.stream.listen(
        (message) async {
          log(message);
          var data = json.decode(message);
          if (data['message'] != null) {
            onMessage(data['message'], data['senderUsername']);
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
