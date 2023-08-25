// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:auto_route/auto_route.dart";
import "package:client/core/Injector/injector.dart";
import "package:client/core/helper/websocket/websocket_helper.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../../../common/widgets/avatar.dart';
import '../../../../routes/router.gr.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../bloc/video_call_bloc.dart';

class IncomingCallPage extends StatefulWidget {
  final String caller;
  final Future<Widget>? avatar;
  IncomingCallPage({
    Key? key,
    required this.caller,
  })  : avatar = showAvatar(150, username: caller),
        super(key: key);

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  @override
  void initState() {
    FlutterRingtonePlayer.playRingtone();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      //wrap helps to show the full name in fist line
                      //if there is not enogh space.
                      Text(
                        '${widget.caller} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Calling...  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    builder: (ctx, snpd) {
                      if (snpd.connectionState == ConnectionState.done) {
                        if (snpd.hasData) {
                          return snpd.data!;
                        } else {
                          return const CircleAvatar();
                        }
                      } else {
                        return const CircleAvatar();
                      }
                    },
                    future: widget.avatar,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Injection.injector
                          .get<WebSocketHelper>()
                          .sendRejection(recieverId: widget.caller);
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: Icon(FontAwesomeIcons.phoneSlash,color: Colors.white,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FlutterRingtonePlayer.stop();
                      context.router
                          .push(VideoCallRoute(recieverName: widget.caller));
                      context.read<VideoCallBloc>().add(
                            MakeCallEvent(
                              recieverName: widget.caller,
                              myName: context
                                  .read<AuthenticationCubit>()
                                  .state
                                  .user!
                                  .username,
                            ),
                          );
                    },
                    child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
