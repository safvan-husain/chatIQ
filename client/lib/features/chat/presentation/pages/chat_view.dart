// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';

import 'package:client/provider/unread_messages.dart';
import 'package:client/utils/show_avatar.dart';

import '../../../../pages/profile/avatar/svg_rapper.dart';
import '../../../home/domain/entities/user.dart';
import '../widgets/chat_view_area.dart';
import '../widgets/input_area.dart';

class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late bool isThisFirstCall;
  DrawableRoot? svgRoot;

  // _generateSvg(String? svgCode) async {
  //   svgCode ??= multiavatar(widget.user.username);
  //   return SvgWrapper(svgCode).generateLogo().then((value) {
  //     setState(() {
  //       svgRoot = value!;
  //     });
  //   });
  // }

  @override
  void initState() {
    isThisFirstCall = true;
    context.read<ChatBloc>().add(ShowChatEvent(chatId: widget.user.username));
    // _generateSvg(widget.user.avatar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          log(widget.user.id.toString());
          context.router
              .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
          context.read<ChatBloc>().add(UpdateLastVisitEvent(user: widget.user));
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

  PopupMenuItem _buildPopupItem(String action, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(action),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Text(widget.user.username),
        ],
      ),
      leading: svgRoot == null
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: showAvatar(svgRoot!, 0)),
      titleSpacing: 0,
      actions: [
        PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
                  _buildPopupItem('clear chat', () {}),
                  _buildPopupItem('Block', () {}),
                ])
      ],
    );
  }
}
