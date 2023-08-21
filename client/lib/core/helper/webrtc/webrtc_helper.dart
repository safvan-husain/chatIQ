import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../../constance/color_log.dart';
import '../websocket/websocket_helper.dart';

class WebrtcHelper {
  final WebSocketHelper _webSocketHelper;

  WebrtcHelper(this._webSocketHelper);

  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  late MediaStream _localStream;
  late RTCPeerConnection _peerConnection;

  List<String> candidateList = [];

  late String _caller;

  bool _offer = false;
  bool _isCreatedPC = false;
  bool _isRenderSetted = false;
  bool _isRemoteSetted = false;

  bool get isCreatedPC => _isCreatedPC;
  bool get isRenderSetted => _isRenderSetted;

  RTCVideoRenderer get localVideoRenderer => _localVideoRenderer;
  RTCVideoRenderer get remoteVideoRenderer => _remoteVideoRenderer;

  Future<void> initVideoRenders() async {
    if (!_isRenderSetted) {
      await _localVideoRenderer.initialize();
      await _remoteVideoRenderer.initialize();
    }
    _isRenderSetted = true;
  }

  ///if the json string is an answer give false for isOffer
  ///
  Future<void> setRemoteDescription({
    required String jsonString,
    required bool isOffer,
  }) async {
    await createPeerConnecion();
    await _setRemoteDescription(jsonString);
  }

  void disposeRenders() {
    if (_isRenderSetted) {
      log('disposing renders, webrtcHelper');
      _localVideoRenderer.dispose();
      _remoteVideoRenderer.dispose();
    }
    _isRenderSetted = false;
  }

  void closeConnection({void Function()? websocketEvent}) async {
    await _closePeerConnection();
    if (websocketEvent != null) {
      websocketEvent();
    }
  }

  void addCandidate(jsonString) async {
    if (_isRemoteSetted) {
      dynamic session = _jsonDecode(jsonString);

      dynamic candidate = RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
      _peerConnection.addCandidate(candidate).catchError((e) {
        logError('error candidate $e');
      });
    } else {
      logError('cannot add candidate because remote is not setted');
    }
  }

  Future<void> createAnswer(String reciever, String sender) async {
    if (_isRemoteSetted) {
      await createPeerConnecion();
      _caller = sender;
      logError("creating answer to $reciever");
      Map<String, dynamic> session = await _createAnswer();

      _webSocketHelper.sendAnswer(
        answer: json.encode(session),
        recieverId: reciever,
      );
    } else {
      logError("con't create answer becuase remote not settd");
    }
  }

  void makeVideoCall(String reciever) async {
    _caller = reciever;

    logSuccess("creating offer to $reciever");
    await createPeerConnecion();
    Map<String, dynamic> session = await _createOffer();
    _webSocketHelper.sendOffer(
      offer: json.encode(session),
      recieverId: reciever,
    );
  }

  Future<void> createPeerConnecion() async {
    if (!_isCreatedPC) {
      log('creating connection, webrtcHelper');

      await _createPeerConnection();
      logSuccess('success connection, webrtcHelper');
    } else {
      log("could not create peer connection, it seems already exists");
    }
  }

  void sendAllCandidate() {
    //if offer is created, we save all IceCandidates
    // and send it after rescieving answer

    for (var candidate in candidateList) {
      _webSocketHelper.sendCandidate(candidate: candidate, recieverId: _caller);
    }
  }

  Future<void> _setRemoteDescription(String jsonString) async {
    var session = _jsonDecode(jsonString);
    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    try {
      await _peerConnection.setRemoteDescription(description);
      _isRemoteSetted = true;
      logSuccess('success remote description, webrtcHelper');
    } catch (e) {
      logError(e.toString());
    }
  }

  ///some time json.decode return a string
  ///
  ///this method is used to solve that issue.
  _jsonDecode(String jsonString) {
    dynamic session = json.decode(jsonString);
    if (session is String) {
      session = json.decode(session);
    }
    return session;
  }

  Future<void> _closePeerConnection() async {
    if (_isCreatedPC) {
      log('closing connection, webrtcHelper');
      await _peerConnection.close();
      _isCreatedPC = false;
      _offer = false;
    } else {
      log("peer connection is alredy closed, webrtc helper");
    }
  }

  Future<Map<String, dynamic>> _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

    Map<String, dynamic> session = parse(description.sdp.toString());

    _peerConnection.setLocalDescription(description);
    return session;
  }

  Future<Map<String, dynamic>> _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    Map<String, dynamic> session = parse(description.sdp.toString());
    _offer = true;

    _peerConnection.setLocalDescription(description);
    return session;
  }

  Future<void> _createPeerConnection() async {
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
          _webSocketHelper.sendCandidate(candidate: data, recieverId: _caller);
        }
      }
    };

    pc.onIceConnectionState = (RTCIceConnectionState e) {
      log(e.toString());
    };
    pc.onTrack = (event) {
      // if video track is added set the track to rtc renderer
      if (event.track.kind == 'video') {
        log('remote src setted');
        _remoteVideoRenderer.srcObject = event.streams[0];
      }
    };

    _peerConnection = pc;
    _isCreatedPC = true;
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
    logSuccess('local video renderer loaded successfully');
    return stream;
  }
}
