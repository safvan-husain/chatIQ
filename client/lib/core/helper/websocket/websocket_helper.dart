import 'dart:convert';
import 'dart:developer';

import 'package:client/core/helper/websocket/ws_event.dart';
import 'package:web_socket_channel/io.dart';

import '../../../common/entity/message.dart';
import '../../../constance/color_log.dart';
import '../../../constance/constant_variebles.dart';

class WebSocketHelper {
  static final WebSocketHelper _instance = WebSocketHelper.internal();
  WebSocketHelper.internal();
  factory WebSocketHelper() => _instance;
  late IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;
  late String myId;
  initSocket({
    required myid,
    required void Function(Message, String) onMessage,
    required void Function(WSEvent) onCall,
    required void Function(WSEvent) onAnswer,
    required void Function(WSEvent) onCandidate,
    required void Function(WSEvent) onEnd,
  }) {
    myId = myid;
    try {
      log('connecting websocket with $myid');
      _channel = IOWebSocketChannel.connect("ws://$ipAddress:3000/$myid");
      _channel.stream.listen(
        (message) async {
          if (json.decode(message)['cmd'] != null) {
            // log(message);
          } else {
            WSEvent event = WSEvent.fromJson(message);
            logSuccess(event.eventName);
            if (event.eventName == 'message') {
              onMessage(event.toMessage(), event.senderUsername);
            } else if (event.eventName == "offer") {
              onCall(event);
            } else if (event.eventName == "answer") {
              onAnswer(event);
            } else if (event.eventName == "candidate") {
              onCandidate(event);
            } else if (event.eventName == "end") {
              onEnd(event);
            }
            // log(event.toJson());
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

  void sendMessage({required String message, required String recieverId}) {
    WSEvent data = WSEvent(
      "message",
      myId,
      recieverId,
      message,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendOffer({required String offer, required String recieverId}) {
    WSEvent data = WSEvent(
      "offer",
      myId,
      recieverId,
      offer,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendAnswer({required String answer, required String recieverId}) {
    WSEvent data = WSEvent(
      "answer",
      myId,
      recieverId,
      answer,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendCandidate({required String candidate, required String recieverId}) {
    WSEvent data = WSEvent(
      "candidate",
      myId,
      recieverId,
      candidate,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendEnd({required String recieverId}) {
    WSEvent data = WSEvent(
      "end",
      myId,
      recieverId,
      '',
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendRejection({required String recieverId}) {
    WSEvent data = WSEvent(
      "rejection",
      myId,
      recieverId,
      '',
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendRequest({required String recieverId}) {
    WSEvent data = WSEvent(
      "request",
      myId,
      recieverId,
      '',
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }
}
