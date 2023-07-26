// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/utils/show_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';

import '../../../../provider/unread_messages.dart';
import '../../../../pages/profile/avatar/svg_rapper.dart';
import '../../domain/entities/user.dart';

class UserTile extends StatefulWidget {
  final User user;
  final int newMessageCount;
  const UserTile({
    Key? key,
    required this.user,
    required this.newMessageCount,
  }) : super(key: key);
  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  DrawableRoot? svgRoot;
  _generateSvg(String? svgCode) async {
    svgCode ??= multiavatar(widget.user.username);
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _generateSvg(widget.user.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        //not optimized - refactor note o
        var s =
            state.newMessages.where((x) => x.chatId == widget.user.id).toList();

        return ListTile(
          leading:
              svgRoot == null ? const CircleAvatar() : showAvatar(svgRoot!, 50),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.username),
              Text(widget.user.lastMessage!.content)
            ],
          ),
          trailing: s.isEmpty
              ? const SizedBox()
              : CircleAvatar(
                  radius: 10.0,
                  backgroundColor: Colors.green,
                  child: Text(
                    s[0].messageCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        );
      },
    );
  }
}
