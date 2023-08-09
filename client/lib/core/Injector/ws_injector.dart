import 'dart:async';
import 'package:client/common/entity/message.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';

import 'package:flutter_simple_dependency_injection/injector.dart';

import '../helper/websocket/ws_event.dart';

class WSInjection {
  static final WebSocketHelper _websocketHelper = WebSocketHelper();

  static late Injector injector;
  static Future<void> initWebSocket({
    required myid,
    required void Function(Message, String) onMessage,
    required void Function(WSEvent) onCall,
    required void Function(WSEvent) onAnswer,
    required void Function(WSEvent) onCandidate,
    required void Function(WSEvent) onEnd,
  }) async {
    await _websocketHelper.initSocket(
      myid: myid,
      onMessage: onMessage,
      onCall: onCall,
      onAnswer: onAnswer,
      onCandidate: onCandidate,
      onEnd: onEnd,
    );
    injector = Injector();
    if (!injector.isMapped<WebSocketHelper>()) {
      injector.map<WebSocketHelper>((i) => _websocketHelper, isSingleton: true);
    }
  }

  static Future<void> initWebRTCPeerConnection() async {
    final WebrtcHelper webrtcHelper = WebrtcHelper(_websocketHelper);

    injector = Injector();
    if (!injector.isMapped<WebrtcHelper>()) {
      // await webrtcHelper.createPeerConnecion();
      // await webrtcHelper.initVideoRenders();
      injector.map<WebrtcHelper>((i) => webrtcHelper, isSingleton: true);
    }
  }
}
