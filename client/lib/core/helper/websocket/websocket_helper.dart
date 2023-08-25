import 'dart:convert';
import 'dart:developer';

import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/ws_event.dart';
import 'package:web_socket_channel/io.dart';

import '../../../common/entity/message.dart';
import '../../../constance/constant_variebles.dart';
import '../../Injector/injector.dart';

class WebSocketHelper {
  static final WebSocketHelper _instance = WebSocketHelper.internal();
  WebSocketHelper.internal();
  factory WebSocketHelper() => _instance;
  late IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;

  ///used for create websocket connection.
  late String myId;
  initSocket({
    required myid,
    required void Function(Message, String) onMessage,
    required void Function(WSEvent) onCall,
    required void Function(WSEvent) onAnswer,
    required void Function(WSEvent) onCandidate,
    required void Function() onEnd,
    required void Function() onBusy,
    required void Function(String caller) onRequest,
  }) {
    myId = myid;
    try {
      log('connecting websocket with $myid');
      _channel = IOWebSocketChannel.connect("ws://$ipAddress:3000/$myid");
      _channel.stream.listen(
        (message) async {
          if (json.decode(message)['cmd'] != null) {
          } else {
            WSEvent event = WSEvent.fromJson(message);
            switch (event.eventName) {
              case 'message':
                onMessage(event.toMessage(), event.senderUsername);
                break;
              case 'offer':
                onCall(event);
                break;
              case 'answer':
                onAnswer(event);
                break;
              case 'candidate':
                onCandidate(event);
                break;
              case 'end':
                onEnd();
                break;
              case 'busy':
                onBusy();
                break;
              case 'rejection':
                onBusy();
                break;
              case 'request':
                if (Injection.injector.get<WebrtcHelper>().isCreatedPC) {
                  sendBusy(recieverId: event.senderUsername);
                } else {
                  onRequest(event.senderUsername);
                }
                break;
              default:
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

  void close() {
    _channel.sink.close();
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
    if (_channel.closeCode == null) {
      _channel.sink.add(data.toJson());
    } else {
      throw ('you see');
    }
  }

  void sendRequest({required String recieverId}) {
    WSEvent data = WSEvent(
      "request",
      myId,
      recieverId,
      null,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendBusy({required String recieverId}) {
    WSEvent data = WSEvent(
      "busy",
      myId,
      recieverId,
      null,
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }

  void sendAvailable({required String recieverId}) {
    WSEvent data = WSEvent(
      "available",
      myId,
      recieverId,
      '',
      DateTime.now(),
    );
    _channel.sink.add(data.toJson());
  }
}
