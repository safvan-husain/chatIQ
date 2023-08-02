import 'dart:async';
import 'package:client/common/entity/message.dart';
import 'package:client/core/websocket/websocket_helper.dart';

import 'package:flutter_simple_dependency_injection/injector.dart';

import '../websocket/ws_event.dart';

class WSInjection {
  static final WebSocketHelper _websocketHelper = WebSocketHelper();
  static late Injector injector;
  static Future initInjection({
    required myid,
    required void Function(Message, String) onMessage,
    required void Function(WSEvent) onCall,
    required void Function(WSEvent) onAnswer,
    required void Function(WSEvent) onCandidate,
  }) async {
    await _websocketHelper.initSocket(
      myid: myid,
      onMessage: onMessage,
      onCall: onCall,
      onAnswer: onAnswer,
      onCandidate: onCandidate,
    );
    injector = Injector();
    if (!injector.isMapped<WebSocketHelper>()) {
      injector.map<WebSocketHelper>((i) => _websocketHelper, isSingleton: true);
    }
  }
}
