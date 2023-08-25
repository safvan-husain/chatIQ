import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/router.gr.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../bloc/video_call_bloc.dart';

class ConnectedVideoScreen extends StatelessWidget {
  const ConnectedVideoScreen(
    this.state,
    this.recieverName, {
    super.key,
  });

  final VideoCallState state;
  final String recieverName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RTCVideoView(
              state.remoteVideoRenderer!,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                  width: 80,
                  height: 100,
                  child: RTCVideoView(
                    state.localVideoRenderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildRejectionButton(context),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildRejectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          context.read<VideoCallBloc>().add(EndCallEvent(
                  context.read<AuthenticationCubit>().state.user!.username,
                  recieverName, () {
                context.router.pushAndPopUntil(
                  const HomeRoute(),
                  predicate: (_) => false,
                );
              }));
        },
        child: const FaIcon(
          FontAwesomeIcons.phoneAlt,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
  }
}
