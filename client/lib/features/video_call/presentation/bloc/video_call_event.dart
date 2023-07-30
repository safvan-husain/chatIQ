part of 'video_call_bloc.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object> get props => [];
}

class InitCallEvent extends VideoCallEvent {}
