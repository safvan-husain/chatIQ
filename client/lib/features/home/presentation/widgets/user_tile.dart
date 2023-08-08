// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:client/constance/app_config.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

  late AppConfig _config;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _generateSvg(widget.user.avatar);
  }

  @override
  Widget build(BuildContext context) {
    _config = AppConfig(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        //not optimized - refactor note o
        var s = state.newMessages
            .where((x) => x.user.id == widget.user.id)
            .toList();
        if (s.isEmpty) {
          return ListTile(
            leading: const CircleAvatar(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username,
                  style: const TextStyle(fontSize: 2),
                ),
              ],
            ),
          );
        }
        return ListTile(
          leading: const CircleAvatar(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.username,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: _config.bigTextSize),
                maxLines: 1,
              ),
              Text(
                s[0].user.lastMessage!.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: _config.smallTextSize,
                ),
              )
            ],
          ),
          trailing: s.isEmpty
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      DateFormat.jm().format(s[0].user.lastMessage!.time),
                      style: TextStyle(fontSize: _config.smallTextSize),
                    ),
                    s[0].messageCount > 0
                        ? CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Theme.of(context).focusColor,
                            child: Text(
                              s[0].messageCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
        );
      },
    );
  }
}
