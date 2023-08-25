import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/router.gr.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../bloc/video_call_bloc.dart';

class InitVideoScreen extends StatelessWidget {
  final VideoCallState state;
  const InitVideoScreen(this.recieverName, this.state, {super.key});

  final String recieverName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        RTCVideoView(
          state.localVideoRenderer!,
          mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Text('Calling $recieverName ...'),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildRejectionButton(context),
        )
      ]),
    );
  }

  Padding _buildRejectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () async {
          context.read<VideoCallBloc>().add(
                EndCallEvent(
                    context.read<AuthenticationCubit>().state.user!.username,
                    recieverName, () {
                  context.router.pushAndPopUntil(
                    const HomeRoute(),
                    predicate: (_) => false,
                  );
                }),
              );
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
