// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:http/http.dart' as http;

import 'package:client/core/websocket/websocket_helper.dart';
import 'package:client/features/home/domain/entities/user.dart';

import '../../../../core/Injector/ws_injector.dart';
import '../../../../core/websocket/ws_event.dart';
import '../../domain/entities/message.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource();
  Future<bool> sendMessage(String message, String myid, User to) async {
    WebSocketHelper webSocketHelper = WSInjection.injector.get();
    webSocketHelper.channel.sink.add(
      WSEvent('send', myid, to.username, message).toJson(),
    );
    return true;
  }
}
