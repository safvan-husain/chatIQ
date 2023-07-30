import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/features/video_call/domain/usecases/answer_call.dart';
import 'package:client/features/video_call/domain/usecases/make_call.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../domain/usecases/reject_call.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final MakeCall _makeCall;
  final AnswerCall _answerCall;
  final RejectCall _jejectCall;
  VideoCallBloc(this._makeCall, this._answerCall, this._jejectCall)
      : super(VideoCallInitial()) {
    on<VideoCallEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitCallEvent>((event, emit) async {
      await _initRenderer();
      await _createPeerConnecion();
      emit(MakeCallState(localVideoRenderer: _localVideoRenderer));
    });
  }
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  List<String> candidates = [];
  bool isConnected = false;
  bool isRemoteSetted = false;
  bool _offer = false;
  var count = 0;

  RTCPeerConnection? _peerConnection;
  late MediaStream _localStream;

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

  Future<void> _setRemoteDescription(jsonString) async {
    dynamic session = await jsonDecode(jsonString);

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

        // socketConnection.sent('candidate', data);
        count = count + 1;
        log("$count on candidate");
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
