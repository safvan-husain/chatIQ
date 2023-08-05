import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../websocket/websocket_helper.dart';
import '../websocket/ws_event.dart';

class WebrtcHelper {
  final WebSocketHelper _webSocketHelper;

  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  late MediaStream _localStream;
  late RTCPeerConnection _peerConnection;
  List<String> candidateList = [];
  bool _offer = false;
  late String _caller;

  WebrtcHelper(this._webSocketHelper);

  RTCVideoRenderer get localVideoRenderer => _localVideoRenderer;
  RTCVideoRenderer get remoteVideoRenderer => _remoteVideoRenderer;

  Future<void> initVideoRenders() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  Future<void> setRemoteDescription(String jsonString) async {
    log('jsonString: $jsonString');
    dynamic session = json.decode(jsonString);
    if (session is String) {
      session = json.decode(session);
    }
    log(session is Map<String, dynamic> ? 'session is map' : session);
    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    // print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void closeConnection(String myid, String reciever) async {
    await _peerConnection.close();
    _webSocketHelper.channel.sink
        .add(WSEvent('end', myid, reciever, '', DateTime.now()).toJson());
  }

  void addCandidate(jsonString) async {
    dynamic session = await jsonDecode(jsonString);
    if (session is! Map<String, dynamic>) {
      session = json.decode(session);
    }
    // print(session);
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    _peerConnection
        .addCandidate(candidate)
        .then((value) => print('candidate added'))
        .catchError((e) {
      print('error candidate $e');
    });
  }

  Future<void> createAnswer(String reciever, String sender) async {
    _caller = sender;
    log("creating answer to $reciever");
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

    Map<String, dynamic> session = parse(description.sdp.toString());

    _peerConnection.setLocalDescription(description);
    _webSocketHelper.channel.sink.add(WSEvent(
            'answer', sender, reciever, json.encode(session), DateTime.now())
        .toJson());
  }

  void makeVideoCall(String reciever, String sender) async {
    _caller = reciever;
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    Map<String, dynamic> session = parse(description.sdp.toString());
    _offer = true;

    _peerConnection.setLocalDescription(description);
    _webSocketHelper.channel.sink.add(
        WSEvent('offer', sender, reciever, json.encode(session), DateTime.now())
            .toJson());
  }

  Future<void> createPeerConnecion() async {
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
              WSEvent('candidate', 'me', _caller, data, DateTime.now())
                  .toJson());
        }

        // socketConnection.sent('candidate', data);
      }
    };

    pc.onIceConnectionState = (RTCIceConnectionState e) {
      if (e == RTCIceConnectionState.RTCIceConnectionStateConnected) {}
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
}
