import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/avatar.dart';
import 'package:client/constance/app_config.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../routes/router.gr.dart';
import '../../domain/entities/user.dart';

class UserTile extends StatefulWidget {
  final User user;
  const UserTile({Key? key, required this.user}) : super(key: key);
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
    return InkWell(
      onTap: () {
        context.router.push(
          ChatRoute(userame: widget.user.username),
        );
      },
      child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        //finding new message of this user.
        var s = state.newMessages
            .where((x) => x.user.id == widget.user.id)
            .toList();
        return Card(
          elevation: 0,
          child: ListTile(
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
                      fontWeight: FontWeight.w500,
                      fontSize: _config.bigTextSize),
                  maxLines: 1,
                ),
                if (s.isNotEmpty)
                  if (s[0].user.lastMessage != null)
                    //show the last message text.
                    Text(
                      s[0].user.lastMessage!.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 62, 190, 245),
                        fontSize: _config.smallTextSize,
                      ),
                    ),
              ],
            ),
            trailing: s.isEmpty
                //show last message time and new message count.
                ? const SizedBox()
                : _showLastTimeandNewMessageCount(s, context),
          ),
        );
      }),
    );
  }

  Column _showLastTimeandNewMessageCount(
      List<NewMessages> s, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (s[0].user.lastMessage != null)
          Text(
            _formatDateTime(s[0].user.lastMessage!.time),
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
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime twoDaysAgo = today.subtract(const Duration(days: 2));

  if (dateTime.isAfter(today)) {
    // Today's time
    return DateFormat.jm().format(dateTime);
  } else if (dateTime.isAfter(yesterday)) {
    // Yesterday
    return 'Yesterday';
  } else if (dateTime.isAfter(twoDaysAgo)) {
    // Display date only
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
  } else {
    // Display full date
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
  }
}
