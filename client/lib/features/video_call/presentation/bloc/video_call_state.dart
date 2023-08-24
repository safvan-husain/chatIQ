// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'video_call_bloc.dart';

abstract class VideoCallState extends Equatable {
  final RTCVideoRenderer? localVideoRenderer;
  final RTCVideoRenderer? remoteVideoRenderer;
  const VideoCallState({
    this.localVideoRenderer,
    this.remoteVideoRenderer,
  });

  @override
  List<Object> get props => [];
}

class VideoCallInitial extends VideoCallState {
  const VideoCallInitial({
    super.localVideoRenderer,
    super.remoteVideoRenderer,
  });
}

class MakeCallState extends VideoCallState {
  const MakeCallState({
    required super.localVideoRenderer,
    super.remoteVideoRenderer,
  });
}

class ConnectingCallState extends VideoCallState {
  const ConnectingCallState({
    required super.localVideoRenderer,
    super.remoteVideoRenderer,
  });
}

class AnswerCallState extends VideoCallState {
  const AnswerCallState({
    required super.localVideoRenderer,
    required super.remoteVideoRenderer,
  });
}

class BusyCallState extends VideoCallState {
  const BusyCallState({
    required super.localVideoRenderer,
  });
}
