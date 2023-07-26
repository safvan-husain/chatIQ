import 'dart:async';
import 'package:client/common/entity/message.dart';
import 'package:client/core/websocket/websocket_helper.dart';

import 'package:flutter_simple_dependency_injection/injector.dart';

class WSInjection {
  static final WebSocketHelper _websocketHelper = WebSocketHelper();
  static late Injector injector;
  static Future initInjection(
      String myid, Future<void> Function(Message, String) onMessage) async {
    await _websocketHelper.initSocket(myid, onMessage);
    injector = Injector();
    if (!injector.isMapped<WebSocketHelper>()) {
      injector.map<WebSocketHelper>((i) => _websocketHelper, isSingleton: true);
    }
  }
}
