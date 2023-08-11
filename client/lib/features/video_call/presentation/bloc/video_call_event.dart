// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'video_call_bloc.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object> get props => [];
}

class InitCallEvent extends VideoCallEvent {}

class RequestCallEvent extends VideoCallEvent {
  final String recieverName;
  final String my_name;
  const RequestCallEvent({
    required this.recieverName,
    required this.my_name,
  });
}

class MakeCallEvent extends VideoCallEvent {
  final String recieverName;
  final String my_name;
  const MakeCallEvent({
    required this.recieverName,
    required this.my_name,
  });
}

class ResponseCallEvent extends VideoCallEvent {
  final WSEvent wsEvent;

  const ResponseCallEvent(this.wsEvent);
}

class ResponseAnswerEvent extends VideoCallEvent {
  final WSEvent wsEvent;

  const ResponseAnswerEvent(this.wsEvent);
}

class CandidateEvent extends VideoCallEvent {
  final WSEvent wsEvent;

  const CandidateEvent(this.wsEvent);
}

class EndCallEvent extends VideoCallEvent {
  final String myid;
  final String reciever;
  final void Function() callEnded;
  const EndCallEvent(
    this.myid,
    this.reciever,
    this.callEnded,
  );
}
