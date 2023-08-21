import 'package:client/common/widgets/avatar.dart';
import 'package:client/constance/app_config.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/user.dart';

class UserTile extends StatefulWidget {
  final User user;
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  late AppConfig _config;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget>? avatar = showAvatar(40, username: widget.user.username);
    _config = AppConfig(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        //not optimized - refactor note o
        var s = state.newMessages
            .where((x) => x.user.id == widget.user.id)
            .toList();
        if (s.isEmpty) {
          return ListTile(
            leading: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? const CircleAvatar();
                }
                return const CircleAvatar();
              },
              future: avatar,
            ),
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
          leading: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data ?? const CircleAvatar();
              }
              return const CircleAvatar();
            },
            future: avatar,
          ),
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
                  color: const Color.fromARGB(255, 62, 190, 245),
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
