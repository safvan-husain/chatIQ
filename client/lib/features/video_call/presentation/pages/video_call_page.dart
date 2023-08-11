// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/core/Injector/ws_injector.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
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
  final WebrtcHelper _webrtcHelper = WSInjection.injector.get<WebrtcHelper>();
  late Future<String> _data;
  @override
  void initState() {
    super.initState();
    log("calling init state videoscall");
    _data = setUpConnection();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<String> setUpConnection() async {
    await _webrtcHelper.initVideoRenders();
    // await _webrtcHelper.createPeerConnecion();
    return 'setted';
  }

  @override
  void dispose() {
    log("calling dispose videoscall");
    WidgetsBinding.instance.removeObserver(this);
    // _webrtcHelper.disposeRenders();
    _webrtcHelper.closeConnection();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<VideoCallBloc>().add(EndCallEvent(
          context.read<AuthenticationCubit>().state.user!.username,
          widget.recieverName,
          () {}));
      context.router.pushAndPopUntil(
        const DefaultRoute(),
        predicate: (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log('is video rendered : ${_webrtcHelper.isRenderSetted.toString()}');
    return BlocConsumer<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.localVideoRenderer == null) {
          log("render is null");
        } else {
          log("render is not null");
        }
        if (state is MakeCallState || state is RejectCallState) {
          return Scaffold(
            body: Stack(children: [
              FutureBuilder(
                future: _data,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      return RTCVideoView(
                        _webrtcHelper.localVideoRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          context.read<VideoCallBloc>().add(EndCallEvent(
                                  context
                                      .read<AuthenticationCubit>()
                                      .state
                                      .user!
                                      .username,
                                  widget.recieverName, () {
                                context.router.pushAndPopUntil(
                                  const DefaultRoute(),
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
                                      widget.recieverName, () {
                                    context.router.pushAndPopUntil(
                                      const DefaultRoute(),
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
