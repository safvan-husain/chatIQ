// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/app_config.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/avatar.dart';
import '../../../../core/Injector/injector.dart';
import '../../../../core/helper/webrtc/webrtc_helper.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../../../video_call/presentation/bloc/video_call_bloc.dart';
import '../widgets/chat_view_area.dart';
import '../widgets/input_area.dart';

class ChatPage extends StatefulWidget {
  final String userame;
  const ChatPage({
    Key? key,
    required this.userame,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<Widget>? avatar;
  late AppConfig _config;

  @override
  void initState() {
    context.read<ChatBloc>().add(ShowChatEvent(
          chatId: widget.userame,
          setUsername: () => widget.userame,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _config = AppConfig(context);
    avatar = showAvatar(40, username: widget.userame);
    return WillPopScope(
        onWillPop: () async {
          //used to update last seen message
          //so we can find unread messages.
          context.read<ChatBloc>().add(UpdateLastVisitEvent(
                userName: widget.userame,
                onUpdateLastVisitCompleted: () => context.router
                    .pushAndPopUntil(const HomeRoute(),
                        predicate: (_) => false),
              ));

          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              const Positioned(
                top: 0,
                bottom: 70,
                left: 0,
                right: 0,
                child: ChatViewArea(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: InputArea(
                  widget: widget,
                ),
              )
            ],
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: _config.rW(9),
      elevation: 0,
      title: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: _config.rWP(1)),
              child: FutureBuilder(
                builder: (ctxt, snp) {
                  if (snp.connectionState == ConnectionState.done) {
                    return snp.data ?? const CircleAvatar();
                  }
                  return const CircleAvatar();
                },
                future: avatar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.userame,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: _config.rW(5)),
              ),
            ),
          ],
        ),
      ),
      leading: InkWell(
        onTap: () {
          context.read<ChatBloc>().add(UpdateLastVisitEvent(
                userName: widget.userame,
                onUpdateLastVisitCompleted: () => context.router
                    .pushAndPopUntil(const HomeRoute(),
                        predicate: (_) => false),
              ));
        },
        child: const Icon(Icons.arrow_back_ios_outlined),
      ),
      titleSpacing: 0,
      actions: [
        InkWell(
          onTap: () async {
            await Injection.injector.get<WebrtcHelper>().initVideoRenders();
            await Injection.injector.get<WebrtcHelper>().createPeerConnecion();
            if (context.mounted) {
              context.router.push(VideoCallRoute(recieverName: widget.userame));
              context.read<VideoCallBloc>().add(
                    RequestCallEvent(
                      recieverName: widget.userame,
                      myName: context
                          .read<AuthenticationCubit>()
                          .state
                          .user!
                          .username,
                      onCancel: () {
                        context.router.pushAndPopUntil(const HomeRoute(),
                            predicate: (_) => false);
                      },
                    ),
                  );
            }
          },
          child: FaIcon(
            FontAwesomeIcons.video,
            size: _config.rW(5),
          ),
        ),
        FaIcon(
          FontAwesomeIcons.bars,
          size: _config.rW(5),
        ),
      ]
          .map(
            (i) => Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              child: i,
            ),
          )
          .toList(),
    );
  }
}
