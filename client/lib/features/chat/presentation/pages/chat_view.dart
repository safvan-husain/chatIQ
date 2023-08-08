// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/app_config.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  late bool isThisFirstCall;
  DrawableRoot? svgRoot;
  late AppConfig _config;

  @override
  void initState() {
    isThisFirstCall = true;
    context.read<ChatBloc>().add(ShowChatEvent(chatId: widget.userame));

    // _generateSvg(widget.user.avatar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _config = AppConfig(context);
    return WillPopScope(
        onWillPop: () async {
          context.router
              .pushAndPopUntil(const DefaultRoute(), predicate: (_) => false);
          context
              .read<ChatBloc>()
              .add(UpdateLastVisitEvent(userName: widget.userame));
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              Positioned(
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

  PopupMenuItem _buildPopupItem(String action, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(action),
    );
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
              child: const CircleAvatar(),
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
      leading: const Icon(Icons.arrow_back_ios_outlined),
      titleSpacing: 0,
      actions: [
        InkWell(
          onTap: () {
            context.router.push(VideoCallRoute(recieverName: widget.userame));
            context.read<VideoCallBloc>().add(
                  RequestCallEvent(
                      recieverName: widget.userame,
                      my_name: context
                          .read<AuthenticationCubit>()
                          .state
                          .user!
                          .username),
                );
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
              padding: EdgeInsets.all(5),
              child: i,
            ),
          )
          .toList(),
    );
  }
}
