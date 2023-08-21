import 'package:auto_route/auto_route.dart';
import 'package:client/features/home/presentation/widgets/user_tile.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserWrapper extends StatelessWidget {
  const UserWrapper({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
              // top: (index == 0)
              //     ? BorderSide(color: Theme.of(context).dividerColor)
              //     : BorderSide.none,
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: InkWell(
        onTap: () {
          context.router.push(
            ChatRoute(
              userame: user.username,
            ),
          );
        },
        child: UserTile(
          user: user,
        ),
      ),
    );
  }
}
