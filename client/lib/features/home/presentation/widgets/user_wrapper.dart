import 'package:auto_route/auto_route.dart';
import 'package:client/local_database/message_schema.dart';
import 'package:client/features/home/presentation/widgets/user_tile.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserWrapper extends StatelessWidget {
  const UserWrapper({
    Key? key,
    required this.index,
    required this.user,
    required this.newMessageCount,
  }) : super(key: key);

  final int index;
  final int newMessageCount;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: (index == 0)
                  ? BorderSide(color: Theme.of(context).dividerColor)
                  : BorderSide.none,
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: InkWell(
        onTap: () {
          context.router.push(
            ChatRoute(
              user: user,
            ),
          );
        },
        child: UserTile(
          user: user,
          newMessageCount: newMessageCount,
        ),
      ),
    );
  }
}
