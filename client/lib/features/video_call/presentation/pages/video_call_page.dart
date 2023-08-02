// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../bloc/video_call_bloc.dart';

class VideoCallPage extends StatelessWidget {
  final String recieverName;
  const VideoCallPage({
    Key? key,
    required this.recieverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is MakeCallState) {
          return Scaffold(
            body: RTCVideoView(state.localVideoRenderer!),
          );
        } else if (state is AnswerCallState) {
          return Scaffold(
            body: Column(
              children: [
                Flexible(child: RTCVideoView(state.localVideoRenderer!)),
                Flexible(child: RTCVideoView(state.remoteVideoRenderer!)),
              ],
            ),
          );
        }
        return const Center(
          child: Text('Video call'),
        );
      },
    );
  }
}
