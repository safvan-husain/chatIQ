import 'dart:async';
import 'package:client/core/websocket/websocket_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_simple_dependency_injection/injector.dart';

class WSInjection {
  static final WebSocketHelper _websocketHelper = WebSocketHelper();
  static late Injector injector;
  static Future initInjection(
      String myid, void Function(String, String) onMessage) async {
    await _websocketHelper.initSocket(myid, onMessage);
    injector = Injector();
    injector.map<WebSocketHelper>((i) => _websocketHelper, isSingleton: true);
  }
}
