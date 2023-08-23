import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/ws_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../core/Injector/injector.dart';
import '../../../../core/Injector/ws_injector.dart';
import '../../../../core/helper/websocket/websocket_helper.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  late String caller;
  final WebSocketHelper _webSocketHelper =
      Injection.injector.get<WebSocketHelper>();
  final WebrtcHelper _webrtcHelper = Injection.injector.get<WebrtcHelper>();

  VideoCallBloc() : super(const VideoCallInitial()) {
    on<RequestCallEvent>((event, emit) {
      _webSocketHelper.sendRequest(recieverId: event.recieverName);
      emit(MakeCallState(localVideoRenderer: _webrtcHelper.localVideoRenderer));

      Timer(const Duration(seconds: 20), () {
        //if there is no response after 15 sec
        if (state is MakeCallState) {
          event.onCancel();
        }
      });
    });
    on<MakeCallEvent>(
      (event, emit) async {
        await _webrtcHelper.initVideoRenders();
        caller = event.recieverName;
        _webrtcHelper.makeVideoCall(event.recieverName);
        emit(MakeCallState(
          localVideoRenderer: _webrtcHelper.localVideoRenderer,
        ));
      },
    );
    on<BusyEvent>((event, emit) {
      emit(const BusyCallState());
    });
    on<ResponseCallEvent>(
      (event, emit) async {
        await _webrtcHelper.initVideoRenders();
        await _webrtcHelper.setRemoteDescription(
          jsonString: json.encode(event.wsEvent.message),
          isOffer: true,
        );
        caller = event.wsEvent.senderUsername;
        _webrtcHelper.createAnswer(
          event.wsEvent.senderUsername,
          event.wsEvent.recieverUsername,
        );
        emit(AnswerCallState(
          localVideoRenderer: _webrtcHelper.localVideoRenderer,
          remoteVideoRenderer: _webrtcHelper.remoteVideoRenderer,
        ));
      },
    );
    on<ResponseAnswerEvent>(
      (event, emit) async {
        await _webrtcHelper.setRemoteDescription(
          jsonString: json.encode(event.wsEvent.message),
          isOffer: false,
        );
        emit(
          AnswerCallState(
            localVideoRenderer: _webrtcHelper.localVideoRenderer,
            remoteVideoRenderer: _webrtcHelper.remoteVideoRenderer,
          ),
        );
        _webrtcHelper.sendAllCandidate();
      },
    );
    on<CandidateEvent>(
      (event, emit) {
        _webrtcHelper.addCandidate(event.wsEvent.message);
      },
    );
    on<EndCallEvent>(
      (event, emit) async {
        var currentCalls = await getCurrentCall();
        if (currentCalls != null) {
          await FlutterCallkitIncoming.endAllCalls();
        }

        event.callEnded();
        _webrtcHelper.closeConnection(
          websocketEvent: () =>
              _webSocketHelper.sendEnd(recieverId: event.reciever),
        );
        emit(const VideoCallInitial());
      },
    );
  }
}

Future<dynamic> getCurrentCall() async {
  //check current call from pushkit if possible
  var calls = await FlutterCallkitIncoming.activeCalls();
  if (calls is List) {
    if (calls.isNotEmpty) {
      return calls;
    } else {
      return null;
    }
  }
}
