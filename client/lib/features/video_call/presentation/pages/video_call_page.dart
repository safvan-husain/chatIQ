// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/router.gr.dart';
import '../bloc/video_call_bloc.dart';

class VideoCallPage extends StatefulWidget {
  final String recieverName;
  const VideoCallPage({
    Key? key,
    required this.recieverName,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<VideoCallBloc>().add(EndCallEvent(
            context.read<AuthenticationCubit>().state.user!.username,
            widget.recieverName,
          ));
      context.router.pushAndPopUntil(
        const DefaultRoute(),
        predicate: (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is MakeCallState) {
          return Scaffold(
            body: Stack(children: [
              RTCVideoView(
                state.localVideoRenderer!,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<VideoCallBloc>().add(EndCallEvent(
                                context
                                    .read<AuthenticationCubit>()
                                    .state
                                    .user!
                                    .username,
                                widget.recieverName,
                              ));
                          context.router.pushAndPopUntil(
                            const DefaultRoute(),
                            predicate: (_) => false,
                          );
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.phoneAlt,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(
                          FontAwesomeIcons.microscope,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          );
        } else if (state is AnswerCallState) {
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
                    top: 10, right: 10,
                    // alignment: Alignment.topRight,
                    child: SizedBox(
                        width: 80,
                        height: 100,
                        child: RTCVideoView(
                          state.localVideoRenderer!,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<VideoCallBloc>().add(EndCallEvent(
                                    context
                                        .read<AuthenticationCubit>()
                                        .state
                                        .user!
                                        .username,
                                    widget.recieverName,
                                  ));
                              context.router.pushAndPopUntil(
                                const DefaultRoute(),
                                predicate: (_) => false,
                              );
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.phoneAlt,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 30),
                          InkWell(
                            onTap: () {},
                            child: const FaIcon(
                              FontAwesomeIcons.microscope,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
