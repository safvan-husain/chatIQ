import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/ws_event.dart';
import 'package:client/features/video_call/domain/usecases/answer_call.dart';
import 'package:client/features/video_call/domain/usecases/make_call.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../core/Injector/ws_injector.dart';
import '../../../../core/helper/websocket/websocket_helper.dart';
import '../../domain/usecases/reject_call.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final MakeCall _makeCall;
  final AnswerCall _answerCall;
  final RejectCall _jejectCall;

  late String caller;
  final WebSocketHelper _webSocketHelper =
      WSInjection.injector.get<WebSocketHelper>();
  final WebrtcHelper _webrtcHelper = WSInjection.injector.get<WebrtcHelper>();

  VideoCallBloc(this._makeCall, this._answerCall, this._jejectCall)
      : super(const VideoCallInitial()) {
    on<RequestCallEvent>((event, emit) {
      _webSocketHelper.channel.sink.add(
        WSEvent(
          "request",
          event.my_name,
          event.recieverName,
          '',
          DateTime.now(),
        ).toJson(),
      );
      emit(MakeCallState(localVideoRenderer: _webrtcHelper.localVideoRenderer));
    });
    on<MakeCallEvent>(
      (event, emit) async {
        log('make call');
        await _webrtcHelper.initVideoRenders();
        await _webrtcHelper.createPeerConnecion();
        caller = event.recieverName;
        _webrtcHelper.makeVideoCall(event.recieverName, event.my_name);
        emit(MakeCallState(
          localVideoRenderer: _webrtcHelper.localVideoRenderer,
        ));
      },
    );
    on<ResponseCallEvent>(
      (event, emit) async {
        log('on response');
        await _webrtcHelper.initVideoRenders();
        // await _webrtcHelper.createPeerConnecion();
        await _webrtcHelper
            .setRemoteDescription(json.encode(event.wsEvent.message));
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
        log('on answer response');
        await _webrtcHelper
            .setRemoteDescription(json.encode(event.wsEvent.message));
        emit(AnswerCallState(
            localVideoRenderer: _webrtcHelper.localVideoRenderer,
            remoteVideoRenderer: _webrtcHelper.remoteVideoRenderer));
        for (String data in _webrtcHelper.candidateList) {
          _webSocketHelper.channel.sink.add(WSEvent('candidate',
                  event.wsEvent.senderUsername, caller, data, DateTime.now())
              .toJson());
        }
      },
    );
    on<CandidateEvent>(
      (event, emit) {
        log('candidate event');
        _webrtcHelper.addCandidate(event.wsEvent.message);
      },
    );
    on<EndCallEvent>(
      (event, emit) async {
        log('end call event');
        var currentCalls = await getCurrentCall();
        if (currentCalls != null) {
          for (var call in currentCalls) {
            await FlutterCallkitIncoming.endCall(call['id']);
          }
        }
        var currentCall = await getCurrentCall();
        if (currentCall != null) {
          log('call could not end in end call event');
        } else {
          log('call ended in end call event');
        }
        event.callEnded();
        // _webrtcHelper.localVideoRenderer.dispose();
        // _webrtcHelper.remoteVideoRenderer.dispose();
        _webrtcHelper.closeConnectionWithEvent(event.myid, event.reciever);
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
      // _currentUuid = calls[0]['id'];
      return calls;
    } else {
      // _currentUuid = "";
      return null;
    }
  }
}
