import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/core/websocket/ws_event.dart';
import 'package:client/features/video_call/domain/usecases/answer_call.dart';
import 'package:client/features/video_call/domain/usecases/make_call.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../../../core/Injector/ws_injector.dart';
import '../../../../core/websocket/websocket_helper.dart';
import '../../domain/usecases/reject_call.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final MakeCall _makeCall;
  final AnswerCall _answerCall;
  final RejectCall _jejectCall;
  late String caller;
  final WebSocketHelper _webSocketHelper = WSInjection.injector.get();
  VideoCallBloc(this._makeCall, this._answerCall, this._jejectCall)
      : super(const VideoCallInitial()) {
    on<VideoCallEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MakeCallEvent>(
      (event, emit) async {
        log('make call');
        await _initRenderer();
        await _createPeerConnecion();
        _makeVideoCall(event.recieverName, event.my_name);
        emit(MakeCallState(localVideoRenderer: _localVideoRenderer));
      },
    );
    on<ResponseCallEvent>(
      (event, emit) async {
        log('on response');
        await _initRenderer();
        await _createPeerConnecion();
        await _setRemoteDescription(json.encode(event.wsEvent.message));
        caller = event.wsEvent.senderUsername;
        _createAnswer(
          event.wsEvent.senderUsername,
          event.wsEvent.recieverUsername,
        );
        emit(AnswerCallState(
            localVideoRenderer: _localVideoRenderer,
            remoteVideoRenderer: _remoteVideoRenderer));
      },
    );
    on<ResponseAnswerEvent>(
      (event, emit) {
        log('on answer response');
        _setRemoteDescription(json.encode(event.wsEvent.message));
        emit(AnswerCallState(
            localVideoRenderer: _localVideoRenderer,
            remoteVideoRenderer: _remoteVideoRenderer));
        for (String data in candidateList) {
          _webSocketHelper.channel.sink.add(
              WSEvent('candidate', 'me', caller, data, DateTime.now())
                  .toJson());
        }
      },
    );
    on<CandidateEvent>(
      (event, emit) {
        log('candidate event');
        _addCandidate(event.wsEvent.message);
      },
    );
  }
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  List<String> candidates = [];
  List<String> candidateList = [];
  bool isConnected = false;
  bool isRemoteSetted = false;
  bool _offer = false;
  var count = 0;

  RTCPeerConnection? _peerConnection;
  late MediaStream _localStream;
  void _makeVideoCall(String reciever, String sender) async {
    caller = reciever;
    _webSocketHelper.channel.sink.add('hi hello');
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    Map<String, dynamic> session = parse(description.sdp.toString());
    _offer = true;

    _peerConnection!.setLocalDescription(description);
    _webSocketHelper.channel.sink.add(
        WSEvent('offer', sender, reciever, json.encode(session), DateTime.now())
            .toJson());
  }

  Future<void> _createAnswer(String reciever, String sender) async {
    log("creating answer to $reciever");
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    Map<String, dynamic> session = parse(description.sdp.toString());

    _peerConnection!.setLocalDescription(description);
    _webSocketHelper.channel.sink.add(WSEvent(
            'answer', sender, reciever, json.encode(session), DateTime.now())
        .toJson());
  }

  void _addCandidate(jsonString) async {
    dynamic session = await jsonDecode(jsonString);
    if (session is! Map<String, dynamic>) {
      session = json.decode(session);
    }
    // print(session);
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    _peerConnection!
        .addCandidate(candidate)
        .then((value) => print('candidate added'))
        .catchError((e) {
      print('error candidate $e');
    });
  }

  Future<void> _initRenderer() async {
    eventHandler();
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  Future<void> _setRemoteDescription(String jsonString) async {
    log('jsonString: $jsonString');
    dynamic session = json.decode(jsonString);
    if (session is String) {
      session = json.decode(session);
    }
    log(session is Map<String, dynamic> ? 'session is map' : session);
    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection!.setRemoteDescription(description);
  }

  void eventHandler() async {
    // socketConnection.socket.on('offer', (data) async {
    // _setRemoteDescription(data).then((v) async {
    // await _createAnswer();
    // isRemoteSetted = true;
    // for (var i = 0; i < candidates.length; i++) {
    //   if (isConnected) break;
    //   // _addCandidate(candidates[i]);
    // }
    // }).catchError((v) {
    //   log('error on remote setup on offer');
    // });
    // });
    // socketConnection.socket.on('answer', (data) async {
    // _setRemoteDescription(data).then((value) {
    //   isRemoteSetted = true;
    //   for (var i = 0; i < candidates.length; i++) {
    //     if (isConnected) break;
    //     // _addCandidate(candidates[i]);
    //   }
    // }).catchError((v) {
    //   log('error on remote setup on anser $v');
    // });
    // });
    // socketConnection.socket.on('candidate', (data) async {
    //some times candidate triggering before remote sett
    // if (isRemoteSetted) {
    //   // _addCandidate(data);
    // } else {
    //   // candidates.add(data);
    // }
    // });
  }

  Future<void> _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {
          // "url": "stun:stun.l.google.com:19302",
          "urls": [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
          ]
        },
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();
    MediaStreamTrack audioTrack = _localStream.getAudioTracks()[0];
    MediaStreamTrack videoTrack = _localStream.getVideoTracks()[0];

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addTrack(audioTrack, _localStream);
    pc.addTrack(videoTrack, _localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        String data = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        });
        if (_offer) {
          candidateList.add(data);
        } else {
          _webSocketHelper.channel.sink.add(
              WSEvent('candidate', 'me', caller, data, DateTime.now())
                  .toJson());
        }

        // socketConnection.sent('candidate', data);
      }
    };

    pc.onIceConnectionState = (RTCIceConnectionState e) {
      if (e == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        isConnected == true;
      }
      log(e.toString());
    };

    pc.onTrack = (event) {
      print('Track added: ${event.track.kind}');
      // if video track is added set the track to rtc renderer
      if (event.track.kind == 'video') {
        log('remote src setted');
        _remoteVideoRenderer.srcObject = event.streams[0];
      }
    };

    _peerConnection = pc;
  }
}
