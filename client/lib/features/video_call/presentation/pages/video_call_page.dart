import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../bloc/video_call_bloc.dart';

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is MakeCallState) {
          return Scaffold(
            body: Expanded(child: RTCVideoView(state.localVideoRenderer!)),
          );
        }
        return const Center(
          child: Text('Video call'),
        );
      },
    );
  }
}
