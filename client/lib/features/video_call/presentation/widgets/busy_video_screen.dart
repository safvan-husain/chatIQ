import 'package:auto_route/auto_route.dart';
import 'package:client/core/Injector/injector.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/router.gr.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../bloc/video_call_bloc.dart';

class BusyVideoScreen extends StatelessWidget {
  const BusyVideoScreen(this.recieverName, {super.key});

  final String recieverName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoCallBloc, VideoCallState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (Injection.injector.get<WebrtcHelper>().isRenderSetted)
                RTCVideoView(
                  state.localVideoRenderer!,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Text('Line is Busy'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      context.read<VideoCallBloc>().add(EndCallEvent(
                              context
                                  .read<AuthenticationCubit>()
                                  .state
                                  .user!
                                  .username,
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
