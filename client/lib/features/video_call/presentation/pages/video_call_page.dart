// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:client/core/Injector/ws_injector.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/video_call/presentation/widgets/busy_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routes/router.gr.dart';
import '../bloc/video_call_bloc.dart';
import '../widgets/connected_video_screen.dart';
import '../widgets/init_video_screen.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        const HomeRoute(),
        predicate: (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        if (state is BusyCallState) {
          Timer(const Duration(seconds: 3), () {
            context.router
                .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
          });
        }
      },
      builder: (context, state) {
        if (state is MakeCallState) {
          return InitVideoScreen(widget.recieverName, state);
        } else if (state is AnswerCallState) {
          return ConnectedVideoScreen(state, widget.recieverName);
        } else if (state is BusyCallState) {
          return BusyVideoScreen(widget.recieverName, state);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
